import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_net_app/core/core.dart';
import 'package:pet_net_app/features/patient/presentation/presentation.dart';

class PatientUpdateFormContent extends ConsumerWidget {
  const PatientUpdateFormContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;
    final patientForm = ref.watch(patientUpdateFormProvider);

    _listenToUpdateError(context, ref);
    _listenToUpdateResponse(context, ref);
    _listenToUpdateImageError(context, ref);
    _listenToUpdateImageResponse(context, ref);

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
                  "Editar Mascota",
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
                  Center(
                    child: CustomFilledButton(
                      text: "Cambiar Imagen",
                      style: getSubtitleBoldStyle(context),
                      onPressed: () {
                        context.push("/patient-image-change");
                      },
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  //Container de Información
                  const _PatientForm(),
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
                        ref
                            .read(patientUpdateFormProvider.notifier)
                            .onFormSubmit();
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _listenToUpdateError(
    BuildContext context,
    WidgetRef ref,
  ) {
    ref.listen(
      patientUpdateProvider.select((value) => value.error),
      (previous, next) {
        String messageError = next.message != null
            ? next.message!
            : getErrorMessage(next, context);
        if (next.type != null) {
          if (next.type == CustomErrorType.unauthorized &&
              next.message == "Token is invalid!") {
            ResponseHandler.handle401Response(context, ref, () {
              ref.read(patientUpdateProvider.notifier).resetResponse();
            });
          }
          CustomDialogs().showSnackbar(context, messageError);
          ref.read(patientUpdateProvider.notifier).resetResponse();
        }
      },
    );
  }

  void _listenToUpdateResponse(
    BuildContext context,
    WidgetRef ref,
  ) {
    ref.listen(
      patientUpdateProvider.select((value) => value.response),
      (previous, next) {
        if (next.isNotEmpty) {
          CustomDialogs().showSnackbar(context, next);
          ref.read(patientUpdateProvider.notifier).resetResponse();
        }
      },
    );
  }

  void _listenToUpdateImageError(
    BuildContext context,
    WidgetRef ref,
  ) {
    ref.listen(
      patientUpdateImageProvider.select((value) => value.error),
      (previous, next) {
        String messageError = next.message != null
            ? next.message!
            : getErrorMessage(next, context);
        if (next.type != null) {
          if (next.type == CustomErrorType.unauthorized &&
              next.message == "Token is invalid!") {
            ResponseHandler.handle401Response(context, ref, () {
              ref.read(patientUpdateImageProvider.notifier).resetResponse();
            });
          }
          CustomDialogs().showSnackbar(context, messageError);
          ref.read(patientUpdateImageProvider.notifier).resetResponse();
        }
      },
    );
  }

  void _listenToUpdateImageResponse(
    BuildContext context,
    WidgetRef ref,
  ) {
    ref.listen(
      patientUpdateImageProvider.select((value) => value.response),
      (previous, next) {
        if (next.isNotEmpty) {
          CustomDialogs().showSnackbar(context, next);
          ref.read(patientUpdateImageProvider.notifier).resetResponse();
        }
      },
    );
  }
}

class _PatientForm extends ConsumerStatefulWidget {
  const _PatientForm();

  @override
  _PatientFormState createState() => _PatientFormState();
}

class _PatientFormState extends ConsumerState<_PatientForm> {
  final _txtNombre = TextEditingController();
  final _txtEdad = TextEditingController();
  final _txtPeso = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final patientForm = ref.read(patientUpdateFormProvider);
      _txtNombre.text = patientForm.mascota.value;
      _txtEdad.text = patientForm.edad.value;
      _txtPeso.text = patientForm.peso.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final patientForm = ref.watch(patientUpdateFormProvider);
    return Center(
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
              controller: _txtNombre,
              label: "Nombre",
              onChanged:
                  ref.read(patientUpdateFormProvider.notifier).onMascotaChanged,
              errorMessage: patientForm.isFormPosted
                  ? patientForm.mascota.errorMessage
                  : null,
            ),
            SizedBox(height: size.height * 0.02),
            //Edad
            CustomTextFormField(
              controller: _txtEdad,
              label: "Edad",
              keyboardType: TextInputType.number,
              onChanged:
                  ref.read(patientUpdateFormProvider.notifier).onEdadChanged,
              errorMessage: patientForm.isFormPosted
                  ? patientForm.edad.errorMessage
                  : null,
            ),
            SizedBox(height: size.height * 0.02),
            //Peso
            CustomTextFormField(
              controller: _txtPeso,
              label: "Peso",
              keyboardType: TextInputType.number,
              onChanged:
                  ref.read(patientUpdateFormProvider.notifier).onPesoChanged,
              errorMessage: patientForm.isFormPosted
                  ? patientForm.peso.errorMessage
                  : null,
            ),
            SizedBox(height: size.height * 0.02),
          ],
        ),
      ),
    );
  }
}
