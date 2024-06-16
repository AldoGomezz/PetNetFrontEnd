import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_net_app/core/core.dart';
import 'package:pet_net_app/features/owner/domain/domain.dart';

//Provider
final ownerRegisterProvider =
    StateNotifierProvider<OwnerRegisterNotifier, OwnerRegisterState>(
  (ref) => OwnerRegisterNotifier(
    ownerRepository: DIRepositories.ownerRepository,
    keyValueStorageService: DIServices.keyValueStorageService,
    ref: ref,
  ),
);

//Notifier
class OwnerRegisterNotifier extends StateNotifier<OwnerRegisterState> {
  final OwnerRepository ownerRepository;
  final KeyValueStorageService keyValueStorageService;
  final Ref ref;

  OwnerRegisterNotifier({
    required this.ownerRepository,
    required this.keyValueStorageService,
    required this.ref,
  }) : super(OwnerRegisterState());

  void resetResponse() {
    state = state.copyWith(
      error: CustomError(),
      response: "",
    );
  }

  Future<void> register(OwnerFormRequest request) async {
    try {
      state = state.copyWith(isLoading: true);
      resetResponse();
      final token = await _getToken();
      final response = await ownerRepository.registerOwner(token, request);

      state = state.copyWith(
        response: response,
        isLoading: false,
      );
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
    state = OwnerRegisterState(error: e);
  }

  void _hableGenericError() {
    state = OwnerRegisterState(
      error: CustomError(
        type: CustomErrorType.unhandled,
      ),
    );
  }

  void logout() {
    state = OwnerRegisterState();
  }
}

//State
class OwnerRegisterState {
  final String response;
  final CustomError error;
  final bool isLoading;

  OwnerRegisterState({
    this.response = "",
    CustomError? error,
    this.isLoading = false,
  }) : error = error ?? CustomError();

  OwnerRegisterState copyWith({
    String? response,
    CustomError? error,
    bool? isLoading,
  }) =>
      OwnerRegisterState(
        response: response ?? this.response,
        error: error ?? this.error,
        isLoading: isLoading ?? this.isLoading,
      );
}
