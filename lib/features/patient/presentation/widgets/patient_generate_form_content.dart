import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_net_app/core/core.dart';
import 'package:pet_net_app/features/patient/presentation/presentation.dart';
import 'package:pet_net_app/features/patient/presentation/providers/providers.dart';

class PatientGenerateFormContent extends ConsumerWidget {
  const PatientGenerateFormContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;
    final patientGenerateForm = ref.watch(patientGenerateFormProvider);

    _listenToUpdateError(context, ref);
    _listenToUpdateResponse(context, ref);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: size.height * 0.05),
          Text(
            "Datos del dueño:",
            style: getTitleBoldStyle(context),
          ),
          SizedBox(height: size.height * 0.02),
          CustomTextFormField(
            label: "Nombres",
            style: getSubtitleStyle(context),
            onChanged: ref
                .read(patientGenerateFormProvider.notifier)
                .onNombreDuenoChanged,
            errorMessage: patientGenerateForm.isFormPosted
                ? patientGenerateForm.nombresDueno.errorMessage
                : null,
          ),
          SizedBox(height: size.height * 0.02),
          CustomTextFormField(
            label: "Apellidos",
            style: getSubtitleStyle(context),
            onChanged: ref
                .read(patientGenerateFormProvider.notifier)
                .onApellidosDuenoChanged,
            errorMessage: patientGenerateForm.isFormPosted
                ? patientGenerateForm.apellidosDueno.errorMessage
                : null,
          ),
          SizedBox(height: size.height * 0.02),
          CustomTextFormField(
            label: "DNI",
            style: getSubtitleStyle(context),
            onChanged: ref
                .read(patientGenerateFormProvider.notifier)
                .onDniDuenoChanged,
            errorMessage: patientGenerateForm.isFormPosted
                ? patientGenerateForm.dniDueno.errorMessage
                : null,
          ),
          SizedBox(height: size.height * 0.02),
          CustomTextFormField(
            label: "Correo",
            style: getSubtitleStyle(context),
            onChanged: ref
                .read(patientGenerateFormProvider.notifier)
                .onEmailDuenoChanged,
            errorMessage: patientGenerateForm.isFormPosted
                ? patientGenerateForm.emailDueno.errorMessage
                : null,
          ),
          SizedBox(height: size.height * 0.02),
          CustomTextFormField(
            label: "Teléfono",
            style: getSubtitleStyle(context),
            onChanged: ref
                .read(patientGenerateFormProvider.notifier)
                .onTelefonoDuenoChanged,
            errorMessage: patientGenerateForm.isFormPosted
                ? patientGenerateForm.telefonoDueno.errorMessage
                : null,
          ),
          SizedBox(height: size.height * 0.05),
          Text(
            "Datos del paciente:",
            style: getTitleBoldStyle(context),
          ),
          SizedBox(height: size.height * 0.02),
          CustomTextFormField(
            label: "Mascota",
            style: getSubtitleStyle(context),
            onChanged:
                ref.read(patientGenerateFormProvider.notifier).onMascotaChanged,
            errorMessage: patientGenerateForm.isFormPosted
                ? patientGenerateForm.mascota.errorMessage
                : null,
          ),
          SizedBox(height: size.height * 0.02),
          CustomTextFormField(
            label: "Edad",
            style: getSubtitleStyle(context),
            onChanged:
                ref.read(patientGenerateFormProvider.notifier).onEdadChanged,
            errorMessage: patientGenerateForm.isFormPosted
                ? patientGenerateForm.edad.errorMessage
                : null,
          ),
          SizedBox(height: size.height * 0.02),
          CustomTextFormField(
            label: "Peso",
            style: getSubtitleStyle(context),
            onChanged:
                ref.read(patientGenerateFormProvider.notifier).onPesoChanged,
            errorMessage: patientGenerateForm.isFormPosted
                ? patientGenerateForm.peso.errorMessage
                : null,
          ),
          SizedBox(height: size.height * 0.02),
          CustomTextFormField(
            label: "Comentario",
            style: getSubtitleStyle(context),
            onChanged: ref
                .read(patientGenerateFormProvider.notifier)
                .onComentarioChanged,
            errorMessage: patientGenerateForm.isFormPosted
                ? patientGenerateForm.comentario.errorMessage
                : null,
            maxLines: 2,
          ),
          SizedBox(height: size.height * 0.02),
          Text(
            "Imagen de la mascota",
            style: getSubtitleStyle(context),
          ),
          SizedBox(height: size.height * 0.01),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
            ),
            onPressed: () async {
              final cameraGalleryService = DIServices.cameraGalleryService;
              final file = await cameraGalleryService.selectPhoto();
              if (file != null && context.mounted) {
                CustomDialogs().showAlert(
                  context: context,
                  title: "Imagen seleccionada",
                  subtitle: "La imagen se ha seleccionado correctamente",
                );
                //XFile a bytes
                final bytes = File(file.path).readAsBytesSync();
                ref
                    .read(patientGenerateFormProvider.notifier)
                    .onProfilePhotoChanged(bytes);
                ref
                    .read(patientGenerateFormProvider.notifier)
                    .onProfilePhotoNameChanged(file.path.split("/").last);
              }
            },
            child: Text(
              "Seleccionar imagen",
              style:
                  getSubtitleBoldStyle(context).copyWith(color: Colors.white),
            ),
          ),
          SizedBox(height: size.height * 0.05),
          Center(
            child: patientGenerateForm.isPosting
                ? const CircularProgressIndicator(
                    strokeWidth: 2,
                  )
                : CustomFilledButton(
                    text: "Guardar",
                    onPressed: () {
                      if (patientGenerateForm.profilePhoto == null) {
                        CustomDialogs().showAlert(
                          context: context,
                          title: "Imagen no seleccionada",
                          subtitle:
                              "Por favor seleccione una imagen de la mascota",
                        );
                        return;
                      }
                      ref
                          .read(patientGenerateFormProvider.notifier)
                          .onFormSubmit();
                    },
                  ),
          ),
          SizedBox(height: size.height * 0.03),
        ],
      ),
    );
  }

  void _listenToUpdateError(
    BuildContext context,
    WidgetRef ref,
  ) {
    ref.listen(
      patientGenerateProvider.select((value) => value.error),
      (previous, next) {
        String messageError = next.message != null
            ? next.message!
            : getErrorMessage(next, context);
        if (next.type != null) {
          if (next.type == CustomErrorType.unauthorized &&
              next.message == "Token is invalid!") {
            ResponseHandler.handle401Response(context, ref, () {
              ref.read(patientGenerateProvider.notifier).resetResponse();
            });
          }
          CustomDialogs().showSnackbar(context, messageError);
          ref.read(patientGenerateProvider.notifier).resetResponse();
        }
      },
    );
  }

  void _listenToUpdateResponse(
    BuildContext context,
    WidgetRef ref,
  ) {
    ref.listen(
      patientGenerateProvider.select((value) => value.response),
      (previous, next) {
        if (next.isNotEmpty) {
          CustomDialogs().showSnackbar(context, next);
          ref.read(patientGenerateProvider.notifier).resetResponse();
        }
      },
    );
  }
}
