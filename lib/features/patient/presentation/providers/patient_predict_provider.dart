import 'dart:typed_data';

import 'package:pet_net_app/core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_net_app/features/owner/domain/domain.dart';
import 'package:pet_net_app/features/patient/data/datasources/patient_datasource_impl.dart';

//Provider
final patientPredictProvider =
    StateNotifierProvider<PatientPredictNotifier, PatientPredictState>(
  (ref) => PatientPredictNotifier(
    patientDatasource: PatientDatasourceImpl(),
    keyValueStorageService: DIServices.keyValueStorageService,
    ref: ref,
  ),
);

//Notifier
class PatientPredictNotifier extends StateNotifier<PatientPredictState> {
  final PatientDatasourceImpl patientDatasource;
  final KeyValueStorageService keyValueStorageService;
  final Ref ref;

  PatientPredictNotifier({
    required this.patientDatasource,
    required this.keyValueStorageService,
    required this.ref,
  }) : super(PatientPredictState());

  void resetResponse() {
    state = state.copyWith(
      error: CustomError(),
      response: "",
    );
  }

  Future<void> predict(
    int patientId,
    Uint8List profilePhoto,
    String profilePhotoName,
    String? description,
  ) async {
    try {
      state = state.copyWith(isLoading: true);
      resetResponse();
      final token = await _getToken();
      final response = await patientDatasource.predicPatient(
        token,
        patientId,
        profilePhoto,
        profilePhotoName,
        description,
      );
      state = state.copyWith(
        photo: response,
        response: "Patient predicted successfully",
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
    state = PatientPredictState(error: e);
  }

  void _hableGenericError() {
    state = PatientPredictState(
      error: CustomError(
        type: CustomErrorType.unhandled,
      ),
    );
  }

  void logout() {
    state = PatientPredictState();
  }
}

//State
class PatientPredictState {
  final Photo? photo;
  final String response;
  final CustomError error;
  final bool isLoading;

  PatientPredictState({
    this.photo,
    this.response = "",
    CustomError? error,
    this.isLoading = false,
  }) : error = error ?? CustomError();

  PatientPredictState copyWith({
    Photo? photo,
    String? response,
    CustomError? error,
    bool? isLoading,
  }) =>
      PatientPredictState(
        photo: photo ?? this.photo,
        response: response ?? this.response,
        error: error ?? this.error,
        isLoading: isLoading ?? this.isLoading,
      );
}
