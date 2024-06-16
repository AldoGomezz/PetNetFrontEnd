import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:pet_net_app/core/core.dart';
import 'package:pet_net_app/features/profile/domain/domain.dart';
import 'package:pet_net_app/features/profile/presentation/providers/profile_update_provider.dart';
import 'package:pet_net_app/features/user/presentation/presentation.dart';

//StateNotifierProvider
final profileFormProvider =
    StateNotifierProvider<ProfileFormNotifier, ProfileFormState>((ref) {
  return ProfileFormNotifier(ref: ref);
});

//Notifier

class ProfileFormNotifier extends StateNotifier<ProfileFormState> {
  Ref ref;
  ProfileFormNotifier({
    required this.ref,
  }) : super(ProfileFormState());

  Future<void> logout() async {
    state = ProfileFormState();
  }

  void setData(UserGetState user) {
    state = state.copyWith(
      clinica: Label.dirty(user.user?.clinic ?? ""),
      direccionClinica: Label.dirty(user.user?.address ?? ""),
      nombreColegiatura: Label.dirty(user.user?.collegeNumber ?? ""),
      nombres: Label.dirty(user.user?.firstName ?? ""),
      apellidos: Label.dirty(user.user?.lastName ?? ""),
      username: Label.dirty(user.user?.username ?? ""),
    );
  }

  onClinicaChange(String value) {
    final newClinica = Label.dirty(value);
    state = state.copyWith(
      clinica: newClinica,
      isValid: Formz.validate([
        state.username,
        newClinica,
        state.direccionClinica,
        state.nombreColegiatura,
        state.nombres,
        state.apellidos,
      ]),
    );
  }

  onDireccionClinicaChange(String value) {
    final newDireccionClinica = Label.dirty(value);
    state = state.copyWith(
      direccionClinica: newDireccionClinica,
      isValid: Formz.validate([
        state.username,
        state.clinica,
        newDireccionClinica,
        state.nombreColegiatura,
        state.nombres,
        state.apellidos,
      ]),
    );
  }

  onNombreColegiaturaChange(String value) {
    final newNombreColegiatura = Label.dirty(value);
    state = state.copyWith(
      nombreColegiatura: newNombreColegiatura,
      isValid: Formz.validate([
        state.username,
        state.clinica,
        state.direccionClinica,
        newNombreColegiatura,
        state.nombres,
        state.apellidos,
      ]),
    );
  }

  onNombresChange(String value) {
    final newNombres = Label.dirty(value);
    state = state.copyWith(
      nombres: newNombres,
      isValid: Formz.validate([
        state.username,
        state.clinica,
        state.direccionClinica,
        state.nombreColegiatura,
        newNombres,
        state.apellidos,
      ]),
    );
  }

  onApellidosChange(String value) {
    final newApellidos = Label.dirty(value);
    state = state.copyWith(
      apellidos: newApellidos,
      isValid: Formz.validate([
        state.username,
        state.clinica,
        state.direccionClinica,
        state.nombreColegiatura,
        state.nombres,
        newApellidos,
      ]),
    );
  }

  onUsernameChange(String value) {
    final newUsername = Label.dirty(value);
    state = state.copyWith(
      username: newUsername,
      isValid: Formz.validate([
        newUsername,
        state.clinica,
        state.direccionClinica,
        state.nombreColegiatura,
        state.nombres,
        state.apellidos,
      ]),
    );
  }

  onFormSubmit(int id) async {
    _touchEveryField();
    if (!state.isValid) return;
    state = state.copyWith(isPosting: true);
    await ref.read(profileUpdateProvider.notifier).updateInfo(
          id,
          UpdateInfoRequest(
            firstName: state.nombres.value,
            lastName: state.apellidos.value,
            clinic: state.clinica.value,
            address: state.direccionClinica.value,
            collegeNumber: state.nombreColegiatura.value,
            username: state.username.value,
          ),
        );
    await ref.read(userGetProvider.notifier).get();
    state = state.copyWith(isPosting: false);
  }

  _touchEveryField() {
    final clinica = Label.dirty(state.clinica.value);
    final direccionClinica = Label.dirty(state.direccionClinica.value);
    final nombreColegiatura = Label.dirty(state.nombreColegiatura.value);
    final nombres = Label.dirty(state.nombres.value);
    final apellidos = Label.dirty(state.apellidos.value);
    final username = Label.dirty(state.username.value);
    state = state.copyWith(
      isFormPosted: true,
      clinica: clinica,
      direccionClinica: direccionClinica,
      nombreColegiatura: nombreColegiatura,
      nombres: nombres,
      apellidos: apellidos,
      username: username,
      isValid: Formz.validate([
        clinica,
        direccionClinica,
        nombreColegiatura,
        nombres,
        apellidos,
        username,
      ]),
    );
  }
}

//State

class ProfileFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Label clinica;
  final Label direccionClinica;
  final Label nombreColegiatura;
  final Label nombres;
  final Label apellidos;
  final Label username;

  ProfileFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.clinica = const Label.pure(),
    this.direccionClinica = const Label.pure(),
    this.nombreColegiatura = const Label.pure(),
    this.nombres = const Label.pure(),
    this.apellidos = const Label.pure(),
    this.username = const Label.pure(),
  });

  ProfileFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Label? clinica,
    Label? direccionClinica,
    Label? nombreColegiatura,
    Label? nombres,
    Label? apellidos,
    Label? username,
  }) =>
      ProfileFormState(
        isPosting: isPosting ?? this.isPosting,
        isFormPosted: isFormPosted ?? this.isFormPosted,
        isValid: isValid ?? this.isValid,
        clinica: clinica ?? this.clinica,
        direccionClinica: direccionClinica ?? this.direccionClinica,
        nombreColegiatura: nombreColegiatura ?? this.nombreColegiatura,
        nombres: nombres ?? this.nombres,
        apellidos: apellidos ?? this.apellidos,
        username: username ?? this.username,
      );
}
