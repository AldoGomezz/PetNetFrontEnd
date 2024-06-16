import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_net_app/core/core.dart';
import 'package:pet_net_app/features/auth/presentation/presentation.dart';

class RegisterFormCard extends ConsumerWidget {
  const RegisterFormCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    final registerForm = ref.watch(registerFormProvider);

    _listenToLoginError(context, ref);
    _listenToLoginResponse(context, ref);

    return SingleChildScrollView(
      child: Column(
        children: [
          Column(
            children: [
              const SizedBox(height: 10),
              AuthCustomTextFormField(
                label: "Clínica",
                style: getSubtitleBoldStyle(context),
                onChanged:
                    ref.read(registerFormProvider.notifier).onClinicaChange,
                errorMessage: registerForm.isFormPosted
                    ? registerForm.clinica.errorMessage
                    : null,
              ),
              SizedBox(height: size.height * 0.025),
              AuthCustomTextFormField(
                label: "Dirección de la clínica",
                style: getSubtitleBoldStyle(context),
                onChanged: ref
                    .read(registerFormProvider.notifier)
                    .onDireccionClinicaChange,
                errorMessage: registerForm.isFormPosted
                    ? registerForm.direccionClinica.errorMessage
                    : null,
              ),
              SizedBox(height: size.height * 0.025),
              AuthCustomTextFormField(
                label: "Número de colegiatura",
                style: getSubtitleBoldStyle(context),
                onChanged: ref
                    .read(registerFormProvider.notifier)
                    .onNroColegiaturaChange,
                errorMessage: registerForm.isFormPosted
                    ? registerForm.nroColegiatura.errorMessage
                    : null,
              ),
              SizedBox(height: size.height * 0.025),
              AuthCustomTextFormField(
                label: "Nombres",
                style: getSubtitleBoldStyle(context),
                onChanged:
                    ref.read(registerFormProvider.notifier).onNombresChange,
                errorMessage: registerForm.isFormPosted
                    ? registerForm.nombres.errorMessage
                    : null,
              ),
              SizedBox(height: size.height * 0.025),
              AuthCustomTextFormField(
                label: "Apellidos",
                style: getSubtitleBoldStyle(context),
                onChanged:
                    ref.read(registerFormProvider.notifier).onApellidosChange,
                errorMessage: registerForm.isFormPosted
                    ? registerForm.apellidos.errorMessage
                    : null,
              ),
              SizedBox(height: size.height * 0.025),
              AuthCustomTextFormField(
                label: "Usuario",
                style: getSubtitleBoldStyle(context),
                onChanged:
                    ref.read(registerFormProvider.notifier).onUsernameChange,
                errorMessage: registerForm.isFormPosted
                    ? registerForm.username.errorMessage
                    : null,
              ),
              SizedBox(height: size.height * 0.025),
              AuthCustomTextFormField(
                label: "Correo",
                style: getSubtitleBoldStyle(context),
                onChanged:
                    ref.read(registerFormProvider.notifier).onEmailChange,
                errorMessage: registerForm.isFormPosted
                    ? registerForm.email.errorMessage
                    : null,
              ),
              SizedBox(height: size.height * 0.025),
              AuthCustomTextFormFieldStateful(
                label: "Contraseña",
                style: getSubtitleBoldStyle(context),
                obscureText: true,
                onChanged:
                    ref.read(registerFormProvider.notifier).onPasswordChange,
                errorMessage: registerForm.isFormPosted
                    ? registerForm.password.errorMessage
                    : null,
              ),
              SizedBox(height: size.height * 0.025),
              AuthCustomTextFormFieldStateful(
                label: "Confirmar Contraseña",
                hint: "********",
                obscureText: true,
                onChanged: ref
                    .read(registerFormProvider.notifier)
                    .onConfirmPasswordChange,
                errorMessage: registerForm.isFormPosted
                    ? (registerForm.passwordsDoNotMatch
                        ? "Las contraseñas no coinciden"
                        : registerForm.confirmPassword.errorMessage)
                    : null,
              ),
              const SizedBox(height: 10),
            ],
          ),
          SizedBox(height: size.height * 0.05),
          registerForm.isPosting
              ? const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : Center(
                  child: CustomFilledButton(
                    text: "Registrarse",
                    style: getSubtitleBoldStyle(context).copyWith(
                      color: Colors.white,
                    ),
                    buttonColor: colorScheme.primary,
                    onPressed: () =>
                        ref.read(registerFormProvider.notifier).onFormSubmit(),
                    height: size.height * 0.07,
                    width: size.width * 0.6,
                  ),
                ),
          SizedBox(height: size.height * 0.05),
        ],
      ),
    );
  }

  void _listenToLoginError(
    BuildContext context,
    WidgetRef ref,
  ) {
    ref.listen(
      authProvider.select((value) => value.error),
      (previous, next) {
        String messageError = next.message != null
            ? next.message!
            : getErrorMessage(next, context);
        if (next.type != null) {
          if (next.type == CustomErrorType.unauthorized &&
              next.message == "Token is invalid!") {
            ResponseHandler.handle401Response(context, ref, () {
              ref.read(authProvider.notifier).resetResponse();
            });
          }
          CustomDialogs().showSnackbar(context, messageError);
          ref.read(authProvider.notifier).resetResponse();
        }
      },
    );
  }

  void _listenToLoginResponse(
    BuildContext context,
    WidgetRef ref,
  ) {
    ref.listen(
      authProvider.select((value) => value.response),
      (previous, next) {
        if (next.isNotEmpty) {
          CustomDialogs().showAlert(
              context: context,
              title: "Registro",
              subtitle: next,
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: const Text("Aceptar"),
                ),
              ]);
          ref.read(authProvider.notifier).resetResponse();
        }
      },
    );
  }
}
