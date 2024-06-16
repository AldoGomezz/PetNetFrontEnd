import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_net_app/core/core.dart';
import 'package:pet_net_app/features/user/domain/domain.dart';

//Provider
final userGetProvider = StateNotifierProvider<UserGetNotifier, UserGetState>(
  (ref) => UserGetNotifier(
    userRepository: DIRepositories.userRepository,
    keyValueStorageService: DIServices.keyValueStorageService,
    ref: ref,
  ),
);

//Notifier
class UserGetNotifier extends StateNotifier<UserGetState> {
  final UserRepository userRepository;
  final KeyValueStorageService keyValueStorageService;
  final Ref ref;

  UserGetNotifier({
    required this.userRepository,
    required this.keyValueStorageService,
    required this.ref,
  }) : super(UserGetState());

  void resetResponse() {
    state = state.copyWith(
      error: CustomError(),
      response: "",
    );
  }

  Future<void> get() async {
    try {
      state = state.copyWith(isLoading: true);
      resetResponse();
      final token = await _getToken();
      final response = await userRepository.getUser(token);
      state = state.copyWith(user: response, isLoading: false);
    } on CustomError catch (e) {
      resetResponse();
      _handleCustomError(e);
    } catch (e) {
      _hableGenericError();
    }
  }

  Future<void> decodeToken(String token) async {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw const FormatException('Invalid token');
    }

    final payload = parts[1];
    final normalized = base64Url.normalize(payload);
    final resp = utf8.decode(base64Url.decode(normalized));

    UserModel user = UserModel.fromJson(json.decode(resp));

    state = state.copyWith(user: user);
  }

  Future<String> _getToken() async {
    final token = await keyValueStorageService.getValue<String>("token");
    if (token == null) {
      throw CustomError(type: CustomErrorType.unauthorized);
    }
    return token;
  }

  void _handleCustomError(CustomError e) {
    state = UserGetState(error: e);
  }

  void _hableGenericError() {
    state = UserGetState(
      error: CustomError(
        type: CustomErrorType.unhandled,
      ),
    );
  }

  void logout() {
    state = UserGetState();
  }
}

//State
class UserGetState {
  final UserModel? user;
  final String response;
  final CustomError error;
  final bool isLoading;

  UserGetState({
    this.user,
    this.response = "",
    CustomError? error,
    this.isLoading = false,
  }) : error = error ?? CustomError();

  UserGetState copyWith({
    UserModel? user,
    String? response,
    CustomError? error,
    bool? isLoading,
  }) =>
      UserGetState(
        user: user ?? this.user,
        response: response ?? this.response,
        error: error ?? this.error,
        isLoading: isLoading ?? this.isLoading,
      );
}
