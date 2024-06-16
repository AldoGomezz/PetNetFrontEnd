import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_net_app/core/core.dart';
import 'package:pet_net_app/features/auth/domain/domain.dart';
import 'package:pet_net_app/features/user/presentation/presentation.dart';

//Provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(
    authRepository: DIRepositories.authRepository,
    keyValueStorageService: DIServices.keyValueStorageService,
    ref: ref,
  ),
);

//Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository authRepository;
  final KeyValueStorageService keyValueStorageService;
  final Ref ref;

  AuthNotifier({
    required this.authRepository,
    required this.keyValueStorageService,
    required this.ref,
  }) : super(AuthState()) {
    checkAuthStatus();
  }

  void resetResponse() {
    state = state.copyWith(
      error: CustomError(),
      response: "",
    );
  }

  Future<void> checkAuthStatus() async {
    try {
      final token = await keyValueStorageService.getValue<String>("token");
      if (token == null) return logout();
      final response = await authRepository.renewToken(token);

      await _saveToken(response);
      await ref.read(userGetProvider.notifier).decodeToken(response);

      state = state.copyWith(
        authStatus: AuthStatus.authenticated,
      );
    } on CustomError catch (e) {
      resetResponse();
      _handleCustomError(e);
    } catch (e) {
      _hableGenericError();
    }
  }

  Future<void> login(String username, String password) async {
    try {
      resetResponse();
      final response = await authRepository.login(
        LoginRequest(
          username: username,
          password: password,
        ),
      );
      await _saveToken(response);
      await ref.read(userGetProvider.notifier).decodeToken(response);
      state = state.copyWith(
        authStatus: AuthStatus.authenticated,
      );
    } on CustomError catch (e) {
      resetResponse();
      _handleCustomError(e);
    } catch (e) {
      _hableGenericError();
    }
  }

  Future<void> register(RegisterRequest request) async {
    try {
      resetResponse();
      final response = await authRepository.register(request);
      state = state.copyWith(
        response: response,
      );
    } on CustomError catch (e) {
      resetResponse();
      _handleCustomError(e);
    } catch (e) {
      _hableGenericError();
    }
  }

  Future<void> _saveToken(String token) async {
    await keyValueStorageService.setKeyValue<String>(
      "token",
      token,
    );
  }

  void _handleCustomError(CustomError e) {
    state = AuthState(
      authStatus: AuthStatus.notAuthenticated,
      error: e,
    );
  }

  void _hableGenericError() {
    state = AuthState(
      authStatus: AuthStatus.notAuthenticated,
      error: CustomError(type: CustomErrorType.unhandled),
    );
  }

  void logout() async {
    await keyValueStorageService.removeKey("token");
    await keyValueStorageService.removeKey("dni");
    state = AuthState(authStatus: AuthStatus.notAuthenticated);
  }
}

//State
enum AuthStatus { checking, authenticated, notAuthenticated }

class AuthState {
  final AuthStatus authStatus;
  final CustomError error;
  final String response;

  AuthState({
    this.authStatus = AuthStatus.checking,
    CustomError? error,
    this.response = "",
  }) : error = error ?? CustomError();

  AuthState copyWith({
    AuthStatus? authStatus,
    CustomError? error,
    String? response,
  }) =>
      AuthState(
        authStatus: authStatus ?? this.authStatus,
        error: error ?? this.error,
        response: response ?? this.response,
      );
}
