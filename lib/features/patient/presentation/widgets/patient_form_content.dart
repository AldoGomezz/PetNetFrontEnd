import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_net_app/core/core.dart';
import 'package:pet_net_app/features/patient/presentation/presentation.dart';

class PatientFormContent extends ConsumerWidget {
  const PatientFormContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;
    final patientForm = ref.watch(patientRegisterFormProvider);

    _listenToRegisterError(context, ref);
    _listenToUpdateResponse(context, ref);

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Titulo
            Center(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  "Crear Mascota",
                  style: getTitleBoldStyle(context),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: size.height * 0.05),
            //Container Patient
            Container(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
              decoration: BoxDecoration(
                color: colorScheme.tertiary,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.height * 0.02),
                  //Imagen
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      patientForm.profilePhoto != null
                          ? Image.memory(
                              patientForm.profilePhoto!,
                              height: size.height * 0.15,
                            )
                          : Icon(
                              Icons.pets,
                              size: size.height * 0.15,
                              color: colorScheme.secondary,
                            ),
                      SizedBox(width: size.width * 0.02),
                      IconButton(
                        onPressed: () async {
                          final cameraGalleryService =
                              DIServices.cameraGalleryService;
                          final file = await cameraGalleryService.selectPhoto();
                          if (file != null && context.mounted) {
                            CustomDialogs().showAlert(
                              context: context,
                              title: "Imagen seleccionada",
                              subtitle:
                                  "La imagen se ha seleccionado correctamente",
                            );
                            //XFile a bytes
                            final bytes = File(file.path).readAsBytesSync();
                            ref
                                .read(patientRegisterFormProvider.notifier)
                                .onProfilePhotoChanged(bytes);
                            ref
                                .read(patientRegisterFormProvider.notifier)
                                .onProfilePhotoNameChanged(
                                    file.path.split("/").last);
                          }
                        },
                        icon: Icon(
                          Icons.camera_alt,
                          size: size.height * 0.03,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.03),
                  //Container de Información
                  Center(
                    child: Container(
                      width: double.maxFinite,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white60,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Información Mascota Formulario:",
                            style: getSubtitleBoldStyle(context),
                          ),
                          SizedBox(height: size.height * 0.02),
                          //Nombre
                          CustomTextFormField(
                            label: "Nombre",
                            onChanged: ref
                                .read(patientRegisterFormProvider.notifier)
                                .onMascotaChanged,
                            errorMessage: patientForm.isFormPosted
                                ? patientForm.mascota.errorMessage
                                : null,
                          ),
                          SizedBox(height: size.height * 0.02),
                          //Edad
                          CustomTextFormField(
                            label: "Edad",
                            keyboardType: TextInputType.number,
                            onChanged: ref
                                .read(patientRegisterFormProvider.notifier)
                                .onEdadChanged,
                            errorMessage: patientForm.isFormPosted
                                ? patientForm.edad.errorMessage
                                : null,
                          ),
                          SizedBox(height: size.height * 0.02),
                          //Peso
                          CustomTextFormField(
                            label: "Peso",
                            keyboardType: TextInputType.number,
                            onChanged: ref
                                .read(patientRegisterFormProvider.notifier)
                                .onPesoChanged,
                            errorMessage: patientForm.isFormPosted
                                ? patientForm.peso.errorMessage
                                : null,
                          ),
                          SizedBox(height: size.height * 0.02),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                ],
              ),
            ),
            SizedBox(height: size.height * 0.05),
            Center(
              child: patientForm.isPosting
                  ? const CircularProgressIndicator(strokeWidth: 2)
                  : CustomFilledButton(
                      text: "Guardar",
                      style: getSubtitleBoldStyle(context),
                      onPressed: () {
                        if (patientForm.profilePhoto == null) {
                          CustomDialogs().showAlert(
                            context: context,
                            title: "Imagen no seleccionada",
                            subtitle:
                                "Por favor seleccione una imagen de la mascota",
                          );
                          return;
                        }
                        ref
                            .read(patientRegisterFormProvider.notifier)
                            .onFormSubmit();
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _listenToRegisterError(
    BuildContext context,
    WidgetRef ref,
  ) {
    ref.listen(
      patientRegisterProvider.select((value) => value.error),
      (previous, next) {
        String messageError = next.message != null
            ? next.message!
            : getErrorMessage(next, context);
        if (next.type != null) {
          if (next.type == CustomErrorType.unauthorized &&
              next.message == "Token is invalid!") {
            ResponseHandler.handle401Response(context, ref, () {
              ref.read(patientRegisterProvider.notifier).resetResponse();
            });
          }
          CustomDialogs().showSnackbar(context, messageError);
          ref.read(patientRegisterProvider.notifier).resetResponse();
        }
      },
    );
  }

  void _listenToUpdateResponse(
    BuildContext context,
    WidgetRef ref,
  ) {
    ref.listen(
      patientRegisterProvider.select((value) => value.response),
      (previous, next) {
        if (next.isNotEmpty) {
          CustomDialogs().showSnackbar(context, next);
          ref.read(patientRegisterProvider.notifier).resetResponse();
        }
      },
    );
  }
}
