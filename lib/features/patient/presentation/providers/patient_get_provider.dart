import 'package:pet_net_app/core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_net_app/features/patient/domain/domain.dart';
import 'package:pet_net_app/features/patient/data/datasources/patient_datasource_impl.dart';

//Provider
final patientGetProvider =
    StateNotifierProvider<PatientGetNotifier, PatientGetState>(
  (ref) => PatientGetNotifier(
    patientDatasource: PatientDatasourceImpl(),
    keyValueStorageService: DIServices.keyValueStorageService,
    ref: ref,
  ),
);

//Notifier
class PatientGetNotifier extends StateNotifier<PatientGetState> {
  final PatientDatasourceImpl patientDatasource;
  final KeyValueStorageService keyValueStorageService;
  final Ref ref;

  PatientGetNotifier({
    required this.patientDatasource,
    required this.keyValueStorageService,
    required this.ref,
  }) : super(PatientGetState());

  void resetResponse() {
    state = state.copyWith(
      error: CustomError(),
      response: "",
    );
  }

  setPatientModel(PatientModel patient) {
    state = state.copyWith(patient: patient);
  }

  Future<void> get(int patientId) async {
    try {
      state = state.copyWith(isLoading: true);
      resetResponse();
      final token = await _getToken();
      final response = await patientDatasource.getPatient(token, patientId);

      state = state.copyWith(
        patient: response,
        response: "Patient fetched successfully",
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
    state = PatientGetState(error: e);
  }

  void _hableGenericError() {
    state = PatientGetState(
      error: CustomError(
        type: CustomErrorType.unhandled,
      ),
    );
  }

  void logout() {
    state = PatientGetState();
  }
}

//State
class PatientGetState {
  final PatientModel? patient;
  final String response;
  final CustomError error;
  final bool isLoading;

  PatientGetState({
    this.patient,
    this.response = "",
    CustomError? error,
    this.isLoading = false,
  }) : error = error ?? CustomError();

  PatientGetState copyWith({
    PatientModel? patient,
    String? response,
    CustomError? error,
    bool? isLoading,
  }) =>
      PatientGetState(
        patient: patient ?? this.patient,
        response: response ?? this.response,
        error: error ?? this.error,
        isLoading: isLoading ?? this.isLoading,
      );
}
