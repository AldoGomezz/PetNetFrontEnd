import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_net_app/core/core.dart';
import 'package:pet_net_app/features/auth/presentation/presentation.dart';

class LoginFormCard extends ConsumerWidget {
  const LoginFormCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final loginForm = ref.watch(loginFormProvider);
    return Column(
      children: [
        const SizedBox(height: 10),
        AuthCustomTextFormField(
          label: "Usuario",
          hint: "usuario",
          onChanged: ref.read(loginFormProvider.notifier).onUsernameChange,
          errorMessage:
              loginForm.isFormPosted ? loginForm.username.errorMessage : null,
        ),
        const SizedBox(height: 20),
        AuthCustomTextFormFieldStateful(
          label: "Contraseña",
          hint: "********",
          obscureText: true,
          onChanged: ref.read(loginFormProvider.notifier).onPasswordChange,
          errorMessage:
              loginForm.isFormPosted ? loginForm.password.errorMessage : null,
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () {
            /* ref.read(registerFormProvider.notifier).logout();
                      context.push("/register"); */
          },
          child: Text(
            "¿Olvidaste tu clave?",
            style: getSmallSubtitleBoldStyle(context).copyWith(
              color: colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}
