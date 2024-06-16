import 'package:flutter/material.dart';
import 'package:pet_net_app/core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_net_app/features/owner/domain/domain.dart';
import 'package:pet_net_app/features/owner/presentation/presentation.dart';
import 'package:pet_net_app/features/owner/presentation/providers/providers.dart';

class OwnerUpdateFormContent extends ConsumerStatefulWidget {
  final OwnerModel owner;
  const OwnerUpdateFormContent({super.key, required this.owner});

  @override
  OwnerUpdateFormContentState createState() => OwnerUpdateFormContentState();
}

class OwnerUpdateFormContentState
    extends ConsumerState<OwnerUpdateFormContent> {
  final _txtDni = TextEditingController();
  final _txtNombres = TextEditingController();
  final _txtApellidos = TextEditingController();
  final _txtTelefono = TextEditingController();
  final _txtEmail = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(ownerUpdateFormProvider.notifier).setData(widget.owner);
      _txtDni.text = widget.owner.document ?? "";
      _txtNombres.text = widget.owner.firstName ?? "";
      _txtApellidos.text = widget.owner.lastName ?? "";
      _txtTelefono.text = widget.owner.phoneNumber ?? "";
      _txtEmail.text = widget.owner.email ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;
    final ownerUpdateFormPv = ref.watch(ownerUpdateFormProvider);

    _listenToUpdateError(context, ref);
    _listenToUpdateResponse(context, ref);

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
                    controller: _txtDni,
                    label: "DNI",
                    style: getSubtitleBoldStyle(context),
                    onChanged: ref
                        .read(ownerUpdateFormProvider.notifier)
                        .onDniDuenoChanged,
                    errorMessage: ownerUpdateFormPv.isFormPosted
                        ? ownerUpdateFormPv.dniDueno.errorMessage
                        : null,
                  ),
                  SizedBox(height: size.height * 0.02),
                  CustomTextFormField(
                    controller: _txtNombres,
                    label: "Nombres",
                    style: getSubtitleBoldStyle(context),
                    onChanged: ref
                        .read(ownerUpdateFormProvider.notifier)
                        .onNombreDuenoChanged,
                    errorMessage: ownerUpdateFormPv.isFormPosted
                        ? ownerUpdateFormPv.nombresDueno.errorMessage
                        : null,
                  ),
                  SizedBox(height: size.height * 0.02),
                  CustomTextFormField(
                    controller: _txtApellidos,
                    label: "Apellidos",
                    style: getSubtitleBoldStyle(context),
                    onChanged: ref
                        .read(ownerUpdateFormProvider.notifier)
                        .onApellidosDuenoChanged,
                    errorMessage: ownerUpdateFormPv.isFormPosted
                        ? ownerUpdateFormPv.apellidosDueno.errorMessage
                        : null,
                  ),
                  SizedBox(height: size.height * 0.02),
                  CustomTextFormField(
                    controller: _txtTelefono,
                    label: "Teléfono",
                    style: getSubtitleBoldStyle(context),
                    onChanged: ref
                        .read(ownerUpdateFormProvider.notifier)
                        .onTelefonoDuenoChanged,
                    errorMessage: ownerUpdateFormPv.isFormPosted
                        ? ownerUpdateFormPv.telefonoDueno.errorMessage
                        : null,
                  ),
                  SizedBox(height: size.height * 0.02),
                  CustomTextFormField(
                    controller: _txtEmail,
                    label: "Correo",
                    style: getSubtitleBoldStyle(context),
                    onChanged: ref
                        .read(ownerUpdateFormProvider.notifier)
                        .onEmailDuenoChanged,
                    errorMessage: ownerUpdateFormPv.isFormPosted
                        ? ownerUpdateFormPv.emailDueno.errorMessage
                        : null,
                  ),
                  SizedBox(height: size.height * 0.03),
                ],
              ),
            ),
            SizedBox(height: size.height * 0.05),
            Center(
              child: ownerUpdateFormPv.isPosting
                  ? const CircularProgressIndicator(strokeWidth: 2)
                  : CustomFilledButton(
                      text: "Editar",
                      style: getSubtitleBoldStyle(context),
                      onPressed: () => ref
                          .read(ownerUpdateFormProvider.notifier)
                          .onFormSubmit(),
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
      ownerUpdateProvider.select((value) => value.error),
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

  void _listenToUpdateResponse(
    BuildContext context,
    WidgetRef ref,
  ) {
    ref.listen(
      ownerUpdateProvider.select((value) => value.response),
      (previous, next) {
        if (next.isNotEmpty) {
          CustomDialogs().showSnackbar(context, next);
          ref.read(ownerRegisterProvider.notifier).resetResponse();
        }
      },
    );
  }
}
