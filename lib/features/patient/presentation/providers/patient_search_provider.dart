import 'package:pet_net_app/core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_net_app/features/patient/domain/domain.dart';
import 'package:pet_net_app/features/patient/data/datasources/patient_datasource_impl.dart';

//Provider
final patientSearchProvider =
    StateNotifierProvider<PatientSearchNotifier, PatientSearchState>(
  (ref) => PatientSearchNotifier(
    patientDatasource: PatientDatasourceImpl(),
    keyValueStorageService: DIServices.keyValueStorageService,
    ref: ref,
  ),
);

//Notifier
class PatientSearchNotifier extends StateNotifier<PatientSearchState> {
  final PatientDatasourceImpl patientDatasource;
  final KeyValueStorageService keyValueStorageService;
  final Ref ref;

  PatientSearchNotifier({
    required this.patientDatasource,
    required this.keyValueStorageService,
    required this.ref,
  }) : super(PatientSearchState());

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
      final response = await patientDatasource.getPatients(token);

      state = state.copyWith(
        patients: response,
        response: response.isNotEmpty
            ? "Pacientes encontrados"
            : "Pacientes no encontrados",
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
      String newQuery = query.isEmpty ? "*" : query;
      final response = await patientDatasource.searchPatients(token, newQuery);

      state = state.copyWith(
        patients: response,
        response: response.isNotEmpty
            ? "Pacientes encontrados"
            : "Pacientes no encontrados",
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
    state = PatientSearchState(error: e);
  }

  void _hableGenericError() {
    state = PatientSearchState(
      error: CustomError(
        type: CustomErrorType.unhandled,
      ),
    );
  }

  void logout() {
    state = PatientSearchState();
  }
}

//State
class PatientSearchState {
  final List<PatientModel> patients;
  final String response;
  final CustomError error;
  final bool isLoading;

  PatientSearchState({
    this.patients = const [],
    this.response = "",
    CustomError? error,
    this.isLoading = false,
  }) : error = error ?? CustomError();

  PatientSearchState copyWith({
    List<PatientModel>? patients,
    String? response,
    CustomError? error,
    bool? isLoading,
  }) =>
      PatientSearchState(
        patients: patients ?? this.patients,
        response: response ?? this.response,
        error: error ?? this.error,
        isLoading: isLoading ?? this.isLoading,
      );
}
