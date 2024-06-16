import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_net_app/core/core.dart';
import 'package:pet_net_app/features/predict/domain/domain.dart';

//Provider
final predictProvider = StateNotifierProvider<PredictNotifier, PredictState>(
  (ref) => PredictNotifier(
    predictRepository: DIRepositories.predictRepository,
    keyValueStorageService: DIServices.keyValueStorageService,
    ref: ref,
  ),
);

//Notifier
class PredictNotifier extends StateNotifier<PredictState> {
  final PredictRepository predictRepository;
  final KeyValueStorageService keyValueStorageService;
  final Ref ref;

  PredictNotifier({
    required this.predictRepository,
    required this.keyValueStorageService,
    required this.ref,
  }) : super(PredictState());

  void resetResponse() {
    state = state.copyWith(
      error: CustomError(),
      response: "",
    );
  }

  Future<void> predict(
    Uint8List image,
    String imageName,
  ) async {
    try {
      state = state.copyWith(isLoading: true);
      resetResponse();
      final token = await _getToken();
      final response = await predictRepository.predict(token, image, imageName);

      state = state.copyWith(
        predict: response,
        response:
            "Predicted: ${response.className} with ${(response.probability * 100).toStringAsFixed(2)}% confidence",
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
    state = PredictState(error: e);
  }

  void _hableGenericError() {
    state = PredictState(
      error: CustomError(
        type: CustomErrorType.unhandled,
      ),
    );
  }

  void logout() {
    state = PredictState();
  }
}

//State
class PredictState {
  final PredictModel? predict;
  final String response;
  final CustomError error;
  final bool isLoading;

  PredictState({
    this.predict,
    this.response = "",
    CustomError? error,
    this.isLoading = false,
  }) : error = error ?? CustomError();

  PredictState copyWith({
    PredictModel? predict,
    String? response,
    CustomError? error,
    bool? isLoading,
  }) =>
      PredictState(
        predict: predict ?? this.predict,
        response: response ?? this.response,
        error: error ?? this.error,
        isLoading: isLoading ?? this.isLoading,
      );
}
