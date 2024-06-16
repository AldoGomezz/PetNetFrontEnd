import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_net_app/core/core.dart';
import 'package:pet_net_app/features/owner/domain/domain.dart';

//Provider
final ownerUpdateProvider =
    StateNotifierProvider<OwnerUpdateNotifier, OwnerUpdateState>(
  (ref) => OwnerUpdateNotifier(
    ownerRepository: DIRepositories.ownerRepository,
    keyValueStorageService: DIServices.keyValueStorageService,
    ref: ref,
  ),
);

//Notifier
class OwnerUpdateNotifier extends StateNotifier<OwnerUpdateState> {
  final OwnerRepository ownerRepository;
  final KeyValueStorageService keyValueStorageService;
  final Ref ref;

  OwnerUpdateNotifier({
    required this.ownerRepository,
    required this.keyValueStorageService,
    required this.ref,
  }) : super(OwnerUpdateState());

  void resetResponse() {
    state = state.copyWith(
      error: CustomError(),
      response: "",
    );
  }

  Future<void> update(int id, OwnerFormRequest request) async {
    try {
      state = state.copyWith(isLoading: true);
      resetResponse();
      final token = await _getToken();
      final response = await ownerRepository.updateOwner(token, id, request);

      state = state.copyWith(
        owner: response.owner,
        response: response.message,
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
    state = OwnerUpdateState(error: e);
  }

  void _hableGenericError() {
    state = OwnerUpdateState(
      error: CustomError(
        type: CustomErrorType.unhandled,
      ),
    );
  }

  void logout() {
    state = OwnerUpdateState();
  }
}

//State
class OwnerUpdateState {
  final OwnerModel? owner;
  final String response;
  final CustomError error;
  final bool isLoading;

  OwnerUpdateState({
    this.owner,
    this.response = "",
    CustomError? error,
    this.isLoading = false,
  }) : error = error ?? CustomError();

  OwnerUpdateState copyWith({
    OwnerModel? owner,
    String? response,
    CustomError? error,
    bool? isLoading,
  }) =>
      OwnerUpdateState(
        owner: owner ?? this.owner,
        response: response ?? this.response,
        error: error ?? this.error,
        isLoading: isLoading ?? this.isLoading,
      );
}
