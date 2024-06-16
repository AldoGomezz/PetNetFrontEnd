import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_net_app/core/core.dart';
import 'package:pet_net_app/features/owner/domain/domain.dart';

//Provider
final ownerDeleteProvider =
    StateNotifierProvider<OwnerDeleteNotifier, OwnerDeleteState>(
  (ref) => OwnerDeleteNotifier(
    ownerRepository: DIRepositories.ownerRepository,
    keyValueStorageService: DIServices.keyValueStorageService,
    ref: ref,
  ),
);

//Notifier
class OwnerDeleteNotifier extends StateNotifier<OwnerDeleteState> {
  final OwnerRepository ownerRepository;
  final KeyValueStorageService keyValueStorageService;
  final Ref ref;

  OwnerDeleteNotifier({
    required this.ownerRepository,
    required this.keyValueStorageService,
    required this.ref,
  }) : super(OwnerDeleteState());

  void resetResponse() {
    state = state.copyWith(
      error: CustomError(),
      response: "",
    );
  }

  Future<void> delete(int id) async {
    try {
      state = state.copyWith(isLoading: true);
      resetResponse();
      final token = await _getToken();
      final response = await ownerRepository.deleteOwner(token, id);

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
    state = OwnerDeleteState(error: e);
  }

  void _hableGenericError() {
    state = OwnerDeleteState(
      error: CustomError(
        type: CustomErrorType.unhandled,
      ),
    );
  }

  void logout() {
    state = OwnerDeleteState();
  }
}

//State
class OwnerDeleteState {
  final String response;
  final CustomError error;
  final bool isLoading;

  OwnerDeleteState({
    this.response = "",
    CustomError? error,
    this.isLoading = false,
  }) : error = error ?? CustomError();

  OwnerDeleteState copyWith({
    String? response,
    CustomError? error,
    bool? isLoading,
  }) =>
      OwnerDeleteState(
        response: response ?? this.response,
        error: error ?? this.error,
        isLoading: isLoading ?? this.isLoading,
      );
}
