import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_net_app/core/core.dart';
import 'package:pet_net_app/features/profile/domain/domain.dart';

//Provider
final profileUpdateProvider =
    StateNotifierProvider<ProfileUpdateNotifier, ProfileUpdateState>(
  (ref) => ProfileUpdateNotifier(
    profileRepository: DIRepositories.profileRepository,
    keyValueStorageService: DIServices.keyValueStorageService,
    ref: ref,
  ),
);

//Notifier
class ProfileUpdateNotifier extends StateNotifier<ProfileUpdateState> {
  final ProfileRepository profileRepository;
  final KeyValueStorageService keyValueStorageService;
  final Ref ref;

  ProfileUpdateNotifier({
    required this.profileRepository,
    required this.keyValueStorageService,
    required this.ref,
  }) : super(ProfileUpdateState());

  void resetResponse() {
    state = state.copyWith(
      error: CustomError(),
      response: "",
    );
  }

  Future<void> updateInfo(int id, UpdateInfoRequest request) async {
    try {
      state = state.copyWith(isLoading: true);
      resetResponse();
      final token = await _getToken();
      final response = await profileRepository.updateUserInfo(
        token,
        request,
      );
      state = state.copyWith(response: response, isLoading: false);
    } on CustomError catch (e) {
      resetResponse();
      _handleCustomError(e);
    } catch (e) {
      _hableGenericError();
    }
  }

  Future<String> _getToken() async {
    final token = await keyValueStorageService.getValue<String>("token");
    if (token == null) {
      throw CustomError(type: CustomErrorType.unauthorized);
    }
    return token;
  }

  void _handleCustomError(CustomError e) {
    state = ProfileUpdateState(error: e);
  }

  void _hableGenericError() {
    state = ProfileUpdateState(
      error: CustomError(
        type: CustomErrorType.unhandled,
      ),
    );
  }

  void logout() {
    state = ProfileUpdateState();
  }
}

//State
class ProfileUpdateState {
  final String response;
  final CustomError error;
  final bool isLoading;

  ProfileUpdateState({
    this.response = "",
    CustomError? error,
    this.isLoading = false,
  }) : error = error ?? CustomError();

  ProfileUpdateState copyWith({
    String? response,
    CustomError? error,
    bool? isLoading,
  }) =>
      ProfileUpdateState(
        response: response ?? this.response,
        error: error ?? this.error,
        isLoading: isLoading ?? this.isLoading,
      );
}
