import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_net_app/core/core.dart';
import 'package:pet_net_app/features/profile/presentation/presentation.dart';
import 'package:pet_net_app/features/user/presentation/presentation.dart';

class ProfileFormWidget extends ConsumerStatefulWidget {
  const ProfileFormWidget({super.key});

  @override
  ProfileFormWidgetState createState() => ProfileFormWidgetState();
}

class ProfileFormWidgetState extends ConsumerState<ProfileFormWidget> {
  final _txtNombres = TextEditingController();
  final _txtApellidos = TextEditingController();
  final _txtClinica = TextEditingController();
  final _txtDireccionClinica = TextEditingController();
  final _txtNombreColegiatura = TextEditingController();
  final _txtUsername = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userGetInfo = ref.read(userGetProvider);
      _txtNombres.text = userGetInfo.user?.firstName ?? "";
      _txtApellidos.text = userGetInfo.user?.lastName ?? "";
      _txtClinica.text = userGetInfo.user?.clinic ?? "";
      _txtDireccionClinica.text = userGetInfo.user?.address ?? "";
      _txtNombreColegiatura.text = userGetInfo.user?.collegeNumber ?? "";
      _txtUsername.text = userGetInfo.user?.username ?? "";
    });
  }

  @override
  void dispose() {
    super.dispose();
    _txtNombres.dispose();
    _txtApellidos.dispose();
    _txtClinica.dispose();
    _txtUsername.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final userGetInfo = ref.watch(userGetProvider);
    final profileForm = ref.watch(profileFormProvider);
    return SizedBox(
      height: size.height * 0.95,
      width: size.width,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            SizedBox(height: size.height * 0.05),
            CustomTextFormField(
              controller: _txtNombres,
              label: "Nombre",
              onChanged: ref.read(profileFormProvider.notifier).onNombresChange,
              errorMessage: profileForm.isFormPosted
                  ? profileForm.nombres.errorMessage
                  : null,
            ),
            SizedBox(height: size.height * 0.02),
            CustomTextFormField(
              controller: _txtApellidos,
              label: "Apellido",
              onChanged:
                  ref.read(profileFormProvider.notifier).onApellidosChange,
              errorMessage: profileForm.isFormPosted
                  ? profileForm.apellidos.errorMessage
                  : null,
            ),
            SizedBox(height: size.height * 0.02),
            CustomTextFormField(
              controller: _txtClinica,
              label: "Clinica",
              onChanged: ref.read(profileFormProvider.notifier).onClinicaChange,
              errorMessage: profileForm.isFormPosted
                  ? profileForm.clinica.errorMessage
                  : null,
            ),
            SizedBox(height: size.height * 0.02),
            CustomTextFormField(
              controller: _txtDireccionClinica,
              label: "Direccion de la Clinica",
              onChanged: ref
                  .read(profileFormProvider.notifier)
                  .onDireccionClinicaChange,
              errorMessage: profileForm.isFormPosted
                  ? profileForm.direccionClinica.errorMessage
                  : null,
            ),
            SizedBox(height: size.height * 0.02),
            CustomTextFormField(
              controller: _txtNombreColegiatura,
              label: "Numero de Colegiatura",
              onChanged: ref
                  .read(profileFormProvider.notifier)
                  .onNombreColegiaturaChange,
              errorMessage: profileForm.isFormPosted
                  ? profileForm.nombreColegiatura.errorMessage
                  : null,
            ),
            SizedBox(height: size.height * 0.02),
            CustomTextFormField(
              readOnly: true,
              controller: _txtUsername,
              label: "Usuario",
              onChanged:
                  ref.read(profileFormProvider.notifier).onUsernameChange,
              errorMessage: profileForm.isFormPosted
                  ? profileForm.username.errorMessage
                  : null,
            ),
            SizedBox(height: size.height * 0.04),
            profileForm.isPosting
                ? const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : CustomFilledButton(
                    text: "Guardar",
                    onPressed: () {
                      ref.read(profileFormProvider.notifier).onFormSubmit(
                            userGetInfo.user!.userId,
                          );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
