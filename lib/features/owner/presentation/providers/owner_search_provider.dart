import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_net_app/core/core.dart';
import 'package:pet_net_app/features/owner/domain/domain.dart';

//Provider
final ownerSearchProvider =
    StateNotifierProvider<OwnerSearchNotifier, OwnerSearchState>(
  (ref) => OwnerSearchNotifier(
    ownerRepository: DIRepositories.ownerRepository,
    keyValueStorageService: DIServices.keyValueStorageService,
    ref: ref,
  ),
);

//Notifier
class OwnerSearchNotifier extends StateNotifier<OwnerSearchState> {
  final OwnerRepository ownerRepository;
  final KeyValueStorageService keyValueStorageService;
  final Ref ref;

  OwnerSearchNotifier({
    required this.ownerRepository,
    required this.keyValueStorageService,
    required this.ref,
  }) : super(OwnerSearchState());

  void resetResponse() {
    state = state.copyWith(
      error: CustomError(),
      response: "",
    );
  }

  Future<void> search() async {
    try {
      state = state.copyWith(isLoading: true);
      resetResponse();
      final token = await _getToken();
      final response = await ownerRepository.getOwners(token);

      state = state.copyWith(
        owners: response,
        response: response.isNotEmpty
            ? "Owners encontrados"
            : "Owners no encontrados",
        isLoading: false,
      );
    } on CustomError catch (e) {
      resetResponse();
      _handleCustomError(e);
    } catch (e) {
      _hableGenericError();
    }
  }

  Future<void> searchByQuery(String query) async {
    try {
      state = state.copyWith(isLoading: true);
      resetResponse();
      final token = await _getToken();
      final response = await ownerRepository.searchOwner(token, query);

      state = state.copyWith(
        owners: response,
        response: response.isNotEmpty
            ? "Owners encontrados"
            : "Owners no encontrados",
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
    state = OwnerSearchState(error: e);
  }

  void _hableGenericError() {
    state = OwnerSearchState(
      error: CustomError(
        type: CustomErrorType.unhandled,
      ),
    );
  }

  void logout() {
    state = OwnerSearchState();
  }
}

//State
class OwnerSearchState {
  final List<OwnerModel> owners;
  final String response;
  final CustomError error;
  final bool isLoading;

  OwnerSearchState({
    this.owners = const [],
    this.response = "",
    CustomError? error,
    this.isLoading = false,
  }) : error = error ?? CustomError();

  OwnerSearchState copyWith({
    List<OwnerModel>? owners,
    String? response,
    CustomError? error,
    bool? isLoading,
  }) =>
      OwnerSearchState(
        owners: owners ?? this.owners,
        response: response ?? this.response,
        error: error ?? this.error,
        isLoading: isLoading ?? this.isLoading,
      );
}
