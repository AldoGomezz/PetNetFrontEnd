import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:pet_net_app/core/core.dart';
import 'package:pet_net_app/features/auth/presentation/presentation.dart';

//StateNotifierProvider
final loginFormProvider =
    StateNotifierProvider<LoginFormNotifier, LoginFormState>((ref) {
  return LoginFormNotifier(ref: ref);
});

//Notifier

class LoginFormNotifier extends StateNotifier<LoginFormState> {
  Ref ref;
  LoginFormNotifier({
    required this.ref,
  }) : super(LoginFormState());

  void logout() {
    state = state.copyWith(
      username: const Label.pure(),
      password: const Password.pure(),
      isValid: false,
      isFormPosted: false,
      isPosting: false,
    );
  }

  onUsernameChange(String value) {
    final username = Label.dirty(value);
    state = state.copyWith(
      username: username,
      isValid: Formz.validate([username, state.password]),
    );
  }

  onPasswordChange(String value) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
      password: newPassword,
      isValid: Formz.validate([newPassword, state.username]),
    );
  }

  onFormSubmit() async {
    _touchEveryField();
    if (!state.isValid) return;

    state = state.copyWith(isPosting: true);
    await ref.read(authProvider.notifier).login(
          state.username.value,
          state.password.value,
        );
    state = state.copyWith(isPosting: false);
  }

  _touchEveryField() {
    final username = Label.dirty(state.username.value);
    final password = Password.dirty(state.password.value);

    state = state.copyWith(
      isFormPosted: true,
      username: username,
      password: password,
      isValid: Formz.validate([username, password]),
    );
  }
}

//State

class LoginFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Label username;
  final Password password;

  LoginFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.username = const Label.pure(),
    this.password = const Password.pure(),
  });

  LoginFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Label? username,
    Password? password,
  }) =>
      LoginFormState(
        isPosting: isPosting ?? this.isPosting,
        isFormPosted: isFormPosted ?? this.isFormPosted,
        isValid: isValid ?? this.isValid,
        username: username ?? this.username,
        password: password ?? this.password,
      );
}
