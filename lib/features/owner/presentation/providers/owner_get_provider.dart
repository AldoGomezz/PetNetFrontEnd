import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_net_app/core/core.dart';
import 'package:pet_net_app/features/owner/domain/domain.dart';

//Provider
final ownerGetProvider = StateNotifierProvider<OwnerGetNotifier, OwnerGetState>(
  (ref) => OwnerGetNotifier(
    ownerRepository: DIRepositories.ownerRepository,
    keyValueStorageService: DIServices.keyValueStorageService,
    ref: ref,
  ),
);

//Notifier
class OwnerGetNotifier extends StateNotifier<OwnerGetState> {
  final OwnerRepository ownerRepository;
  final KeyValueStorageService keyValueStorageService;
  final Ref ref;

  OwnerGetNotifier({
    required this.ownerRepository,
    required this.keyValueStorageService,
    required this.ref,
  }) : super(OwnerGetState());

  void resetResponse() {
    state = state.copyWith(
      error: CustomError(),
      response: "",
    );
  }

  setOwner(OwnerModel owner) {
    state = state.copyWith(owner: owner);
  }

  Future<void> get(int ownerId) async {
    try {
      state = state.copyWith(isLoading: true);
      resetResponse();
      final token = await _getToken();
      final response = await ownerRepository.getOwner(token, ownerId);

      state = state.copyWith(
        owner: response,
        response: "Owner fetched successfully",
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
    state = OwnerGetState(error: e);
  }

  void _hableGenericError() {
    state = OwnerGetState(
      error: CustomError(
        type: CustomErrorType.unhandled,
      ),
    );
  }

  void logout() {
    state = OwnerGetState();
  }
}

//State
class OwnerGetState {
  final OwnerModel? owner;
  final String response;
  final CustomError error;
  final bool isLoading;

  OwnerGetState({
    this.owner,
    this.response = "",
    CustomError? error,
    this.isLoading = false,
  }) : error = error ?? CustomError();

  OwnerGetState copyWith({
    OwnerModel? owner,
    String? response,
    CustomError? error,
    bool? isLoading,
  }) =>
      OwnerGetState(
        owner: owner ?? this.owner,
        response: response ?? this.response,
        error: error ?? this.error,
        isLoading: isLoading ?? this.isLoading,
      );
}
