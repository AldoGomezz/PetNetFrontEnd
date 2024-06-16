import 'dart:typed_data';
import 'package:pet_net_app/core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_net_app/features/patient/data/datasources/patient_datasource_impl.dart';

//Provider
final patientUpdateImageProvider =
    StateNotifierProvider<PatientUpdateImageNotifier, PatientUpdateImageState>(
  (ref) => PatientUpdateImageNotifier(
    patientDatasource: PatientDatasourceImpl(),
    keyValueStorageService: DIServices.keyValueStorageService,
    ref: ref,
  ),
);

//Notifier
class PatientUpdateImageNotifier
    extends StateNotifier<PatientUpdateImageState> {
  final PatientDatasourceImpl patientDatasource;
  final KeyValueStorageService keyValueStorageService;
  final Ref ref;

  PatientUpdateImageNotifier({
    required this.patientDatasource,
    required this.keyValueStorageService,
    required this.ref,
  }) : super(PatientUpdateImageState());

  void resetResponse() {
    state = state.copyWith(
      error: CustomError(),
      response: "",
    );
  }

  Future<void> updateImage(
    int patientId,
    Uint8List profilePhoto,
    String profilePhotoName,
  ) async {
    try {
      state = state.copyWith(isLoading: true);
      resetResponse();
      final token = await _getToken();
      final response = await patientDatasource.updateImagePatient(
        token,
        patientId,
        profilePhoto,
        profilePhotoName,
      );

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
    state = PatientUpdateImageState(error: e);
  }

  void _hableGenericError() {
    state = PatientUpdateImageState(
      error: CustomError(
        type: CustomErrorType.unhandled,
      ),
    );
  }

  void logout() {
    state = PatientUpdateImageState();
  }
}

//State
class PatientUpdateImageState {
  final String response;
  final CustomError error;
  final bool isLoading;

  PatientUpdateImageState({
    this.response = "",
    CustomError? error,
    this.isLoading = false,
  }) : error = error ?? CustomError();

  PatientUpdateImageState copyWith({
    String? response,
    CustomError? error,
    bool? isLoading,
  }) =>
      PatientUpdateImageState(
        response: response ?? this.response,
        error: error ?? this.error,
        isLoading: isLoading ?? this.isLoading,
      );
}
