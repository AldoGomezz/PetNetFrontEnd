import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_net_app/core/core.dart';
import 'package:pet_net_app/features/auth/presentation/presentation.dart';
import 'package:pet_net_app/features/user/presentation/presentation.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;
    final loginForm = ref.watch(loginFormProvider);

    _listenToLoginError(context, ref);
    _listenToUserGetError(context, ref);

    return Scaffold(
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: SizedBox(
            height: size.height,
            child: Stack(
              children: [
                // Background
                const Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: BackgroundWidget(),
                ),
                // Logo
                Positioned(
                  top: size.height * 0.13,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/logo/pet_net_red.png',
                          height: size.height * 0.12,
                        ),
                        SizedBox(height: size.height * 0.01),
                        Text(
                          "PetNet",
                          style: getHeaderStyle(context).copyWith(
                            color: colorScheme.primary,
                            fontSize: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //Icono de ayuda
                /* Positioned(
                  top: size.height * 0.05,
                  right: size.width * 0.015,
                  child: GestureDetector(
                    onTap: () {},
                    child: Image.asset(
                      'assets/icons/help.png',
                      height: size.height * 0.045,
                    ),
                  ),
                ), */
                // Formulario
                Positioned(
                  top: size.height * 0.4,
                  left: size.width * 0.1,
                  right: size.width * 0.1,
                  child: const LoginFormCard(),
                ),
                // Botón de inicio de sesión
                Positioned(
                  top: size.height * 0.65,
                  left: size.width * 0.1,
                  right: size.width * 0.1,
                  child: Center(
                    child: loginForm.isPosting
                        ? const CircularProgressIndicator(
                            strokeWidth: 2,
                          )
                        : CustomFilledButton(
                            text: "Ingresar",
                            borderRadius: 5,
                            style: getSubtitleBoldStyle(context).copyWith(
                              color: Colors.white,
                            ),
                            buttonColor: colorScheme.primary,
                            onPressed: () => ref
                                .read(loginFormProvider.notifier)
                                .onFormSubmit(),
                            height: size.height * 0.07,
                            width: double.infinity,
                          ),
                  ),
                ),
                // Si no tienes cuenta
                Positioned(
                  top: size.height * 0.76,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        ref.read(registerFormProvider.notifier).logout();
                        context.push("/register");
                      },
                      child: Text(
                        "Registrar",
                        style: getSmallSubtitleBoldStyle(context).copyWith(
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
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

  void _listenToUserGetError(
    BuildContext context,
    WidgetRef ref,
  ) {
    ref.listen(
      userGetProvider.select((value) => value.error),
      (previous, next) {
        String messageError = next.message != null
            ? next.message!
            : getErrorMessage(next, context);
        if (next.type != null) {
          if (next.type == CustomErrorType.unauthorized &&
              next.message == "Token is invalid!") {
            ResponseHandler.handle401Response(context, ref, () {
              ref.read(userGetProvider.notifier).resetResponse();
            });
          }
          CustomDialogs().showSnackbar(context, messageError);
          ref.read(userGetProvider.notifier).resetResponse();
        }
      },
    );
  }
}
