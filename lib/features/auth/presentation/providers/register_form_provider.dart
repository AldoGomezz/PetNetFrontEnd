import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:pet_net_app/core/core.dart';
import 'package:pet_net_app/features/auth/domain/domain.dart';
import 'package:pet_net_app/features/auth/presentation/presentation.dart';

//StateNotifierProvider
final registerFormProvider =
    StateNotifierProvider<RegisterFormNotifier, RegisterFormState>((ref) {
  return RegisterFormNotifier(ref: ref);
});

//Notifier

class RegisterFormNotifier extends StateNotifier<RegisterFormState> {
  Ref ref;
  RegisterFormNotifier({
    required this.ref,
  }) : super(RegisterFormState());

  void logout() {
    state = RegisterFormState();
  }

  onClinicaChange(String value) {
    final newClinica = Label.dirty(value);
    state = state.copyWith(
      clinica: newClinica,
      isValid: Formz.validate([
        state.password,
        state.username,
        state.email,
        newClinica,
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
        state.password,
        state.username,
        state.email,
        state.clinica,
        newDireccionClinica,
        state.nombres,
        state.apellidos,
      ]),
    );
  }

  onNroColegiaturaChange(String value) {
    final newNroColegiatura = Label.dirty(value);
    state = state.copyWith(
      nroColegiatura: newNroColegiatura,
      isValid: Formz.validate([
        state.password,
        state.username,
        state.email,
        state.clinica,
        state.direccionClinica,
        newNroColegiatura,
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
        state.password,
        state.username,
        state.email,
        state.clinica,
        state.direccionClinica,
        state.nroColegiatura,
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
        state.password,
        state.username,
        state.email,
        state.clinica,
        state.direccionClinica,
        state.nroColegiatura,
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
        state.password,
        newUsername,
        state.email,
        state.clinica,
        state.direccionClinica,
        state.nroColegiatura,
        state.nombres,
        state.apellidos,
      ]),
    );
  }

  onPasswordChange(String value) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
      password: newPassword,
      isValid: Formz.validate([
        newPassword,
        state.username,
        state.email,
        state.clinica,
        state.direccionClinica,
        state.nroColegiatura,
        state.nombres,
        state.apellidos,
      ]),
    );
  }

  onEmailChange(String value) {
    final newEmail = Email.dirty(value);
    state = state.copyWith(
      email: newEmail,
      isValid: Formz.validate([
        state.password,
        state.username,
        newEmail,
        state.clinica,
        state.direccionClinica,
        state.nroColegiatura,
        state.nombres,
        state.apellidos,
      ]),
    );
  }

  onConfirmPasswordChange(String value) {
    final newConfirmPassword = Password.dirty(value);
    final passwordsDoNotMatch =
        state.password.value != newConfirmPassword.value;

    state = state.copyWith(
      confirmPassword: newConfirmPassword,
      passwordsDoNotMatch: passwordsDoNotMatch,
      isValid: Formz.validate([
        state.password,
        state.username,
        state.email,
        state.clinica,
        state.direccionClinica,
        state.nroColegiatura,
        state.nombres,
        state.apellidos,
        newConfirmPassword,
      ]),
    );
  }

  onFormSubmit() async {
    _touchEveryField();
    if (!state.isValid) return;
    /* if (state.password.value != state.confirmPassword.value) {
      state = state.copyWith(passwordsDoNotMatch: true);
      return;
    } */
    state = state.copyWith(isPosting: true);
    await ref.read(authProvider.notifier).register(
          RegisterRequest(
            firstName: state.nombres.value,
            lastName: state.apellidos.value,
            email: state.email.value,
            clinic: state.clinica.value,
            address: state.direccionClinica.value,
            collegeNumber: state.nroColegiatura.value,
            username: state.username.value,
            password: state.password.value,
            confirmPassword: state.password.value,
          ),
        );
    state = state.copyWith(isPosting: false);
  }

  _touchEveryField() {
    final clinica = Label.dirty(state.clinica.value);
    final direccionClinica = Label.dirty(state.direccionClinica.value);
    final nroColegiatura = Label.dirty(state.nroColegiatura.value);
    final nombres = Label.dirty(state.nombres.value);
    final apellidos = Label.dirty(state.apellidos.value);
    final username = Label.dirty(state.username.value);
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    final confirmPassword = Password.dirty(state.confirmPassword.value);

    final passwordsDoNotMatch = password.value != confirmPassword.value;

    state = state.copyWith(
      isFormPosted: true,
      clinica: clinica,
      direccionClinica: direccionClinica,
      nroColegiatura: nroColegiatura,
      nombres: nombres,
      apellidos: apellidos,
      username: username,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      passwordsDoNotMatch: passwordsDoNotMatch,
      isValid: Formz.validate([
        clinica,
        direccionClinica,
        nroColegiatura,
        nombres,
        apellidos,
        username,
        email,
        password,
        confirmPassword,
      ]),
    );
  }
}

//State

class RegisterFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Label clinica;
  final Label direccionClinica;
  final Label nroColegiatura;
  final Label nombres;
  final Label apellidos;
  final Label username;
  final Email email;
  final Password password;
  final Password confirmPassword;
  final bool passwordsDoNotMatch;

  RegisterFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.clinica = const Label.pure(),
    this.direccionClinica = const Label.pure(),
    this.nroColegiatura = const Label.pure(),
    this.nombres = const Label.pure(),
    this.apellidos = const Label.pure(),
    this.username = const Label.pure(),
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.confirmPassword = const Password.pure(),
    this.passwordsDoNotMatch = false,
  });

  RegisterFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Label? clinica,
    Label? direccionClinica,
    Label? nroColegiatura,
    Label? nombres,
    Label? apellidos,
    Label? username,
    Email? email,
    Password? password,
    Password? confirmPassword,
    bool? passwordsDoNotMatch,
  }) =>
      RegisterFormState(
        isPosting: isPosting ?? this.isPosting,
        isFormPosted: isFormPosted ?? this.isFormPosted,
        isValid: isValid ?? this.isValid,
        clinica: clinica ?? this.clinica,
        direccionClinica: direccionClinica ?? this.direccionClinica,
        nroColegiatura: nroColegiatura ?? this.nroColegiatura,
        nombres: nombres ?? this.nombres,
        apellidos: apellidos ?? this.apellidos,
        username: username ?? this.username,
        email: email ?? this.email,
        password: password ?? this.password,
        confirmPassword: confirmPassword ?? this.confirmPassword,
        passwordsDoNotMatch: passwordsDoNotMatch ?? this.passwordsDoNotMatch,
      );
}
