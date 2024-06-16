import 'package:flutter/material.dart';
import 'package:pet_net_app/core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_net_app/features/owner/presentation/presentation.dart';
import 'package:pet_net_app/features/owner/presentation/providers/providers.dart';

class OwnerFormContent extends ConsumerWidget {
  const OwnerFormContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;
    final ownerFormPv = ref.watch(ownerFormProvider);

    _listenToRegisterError(context, ref);
    _listenToRegisterResponse(context, ref);

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Titulo
            Center(
              child: Image.asset(
                'assets/logo/pet_net.png',
                height: size.height * 0.12,
              ),
            ),
            SizedBox(height: size.height * 0.05),
            //Container Owner
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
                  CustomTextFormField(
                    label: "DNI",
                    style: getSubtitleBoldStyle(context),
                    onChanged:
                        ref.read(ownerFormProvider.notifier).onDniDuenoChanged,
                    errorMessage: ownerFormPv.isFormPosted
                        ? ownerFormPv.dniDueno.errorMessage
                        : null,
                  ),
                  SizedBox(height: size.height * 0.02),
                  CustomTextFormField(
                    label: "Nombres",
                    style: getSubtitleBoldStyle(context),
                    onChanged: ref
                        .read(ownerFormProvider.notifier)
                        .onNombreDuenoChanged,
                    errorMessage: ownerFormPv.isFormPosted
                        ? ownerFormPv.nombresDueno.errorMessage
                        : null,
                  ),
                  SizedBox(height: size.height * 0.02),
                  CustomTextFormField(
                    label: "Apellidos",
                    style: getSubtitleBoldStyle(context),
                    onChanged: ref
                        .read(ownerFormProvider.notifier)
                        .onApellidosDuenoChanged,
                    errorMessage: ownerFormPv.isFormPosted
                        ? ownerFormPv.apellidosDueno.errorMessage
                        : null,
                  ),
                  SizedBox(height: size.height * 0.02),
                  CustomTextFormField(
                    label: "Teléfono",
                    style: getSubtitleBoldStyle(context),
                    onChanged: ref
                        .read(ownerFormProvider.notifier)
                        .onTelefonoDuenoChanged,
                    errorMessage: ownerFormPv.isFormPosted
                        ? ownerFormPv.telefonoDueno.errorMessage
                        : null,
                  ),
                  SizedBox(height: size.height * 0.02),
                  CustomTextFormField(
                    label: "Correo",
                    style: getSubtitleBoldStyle(context),
                    onChanged: ref
                        .read(ownerFormProvider.notifier)
                        .onEmailDuenoChanged,
                    errorMessage: ownerFormPv.isFormPosted
                        ? ownerFormPv.emailDueno.errorMessage
                        : null,
                  ),
                  SizedBox(height: size.height * 0.03),
                ],
              ),
            ),
            SizedBox(height: size.height * 0.05),
            Center(
              child: ownerFormPv.isPosting
                  ? const CircularProgressIndicator(strokeWidth: 2)
                  : CustomFilledButton(
                      text: "Guardar",
                      style: getSubtitleBoldStyle(context).copyWith(
                        color: Colors.white,
                      ),
                      onPressed: () =>
                          ref.read(ownerFormProvider.notifier).onFormSubmit(),
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
      ownerRegisterProvider.select((value) => value.error),
      (previous, next) {
        String messageError = next.message != null
            ? next.message!
            : getErrorMessage(next, context);
        if (next.type != null) {
          if (next.type == CustomErrorType.unauthorized &&
              next.message == "Token is invalid!") {
            ResponseHandler.handle401Response(context, ref, () {
              ref.read(ownerRegisterProvider.notifier).resetResponse();
            });
          }
          CustomDialogs().showSnackbar(context, messageError);
          ref.read(ownerRegisterProvider.notifier).resetResponse();
        }
      },
    );
  }

  void _listenToRegisterResponse(
    BuildContext context,
    WidgetRef ref,
  ) {
    ref.listen(
      ownerRegisterProvider.select((value) => value.response),
      (previous, next) {
        if (next.isNotEmpty) {
          CustomDialogs().showSnackbar(context, next);
          ref.read(ownerRegisterProvider.notifier).resetResponse();
        }
      },
    );
  }
}
