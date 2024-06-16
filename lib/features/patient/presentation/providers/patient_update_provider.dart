import 'package:pet_net_app/core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_net_app/features/patient/domain/domain.dart';
import 'package:pet_net_app/features/patient/data/datasources/patient_datasource_impl.dart';

//Provider
final patientUpdateProvider =
    StateNotifierProvider<PatientUpdateNotifier, PatientUpdateState>(
  (ref) => PatientUpdateNotifier(
    patientDatasource: PatientDatasourceImpl(),
    keyValueStorageService: DIServices.keyValueStorageService,
    ref: ref,
  ),
);

//Notifier
class PatientUpdateNotifier extends StateNotifier<PatientUpdateState> {
  final PatientDatasourceImpl patientDatasource;
  final KeyValueStorageService keyValueStorageService;
  final Ref ref;

  PatientUpdateNotifier({
    required this.patientDatasource,
    required this.keyValueStorageService,
    required this.ref,
  }) : super(PatientUpdateState());

  void resetResponse() {
    state = state.copyWith(
      error: CustomError(),
      response: "",
    );
  }

  Future<void> update(PatientUpdateRequest patientUpdate, int patientId) async {
    try {
      state = state.copyWith(isLoading: true);
      resetResponse();
      final token = await _getToken();
      final response = await patientDatasource.updatePatient(
        token,
        patientUpdate,
        patientId,
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
    state = PatientUpdateState(error: e);
  }

  void _hableGenericError() {
    state = PatientUpdateState(
      error: CustomError(
        type: CustomErrorType.unhandled,
      ),
    );
  }

  void logout() {
    state = PatientUpdateState();
  }
}

//State
class PatientUpdateState {
  final String response;
  final CustomError error;
  final bool isLoading;

  PatientUpdateState({
    this.response = "",
    CustomError? error,
    this.isLoading = false,
  }) : error = error ?? CustomError();

  PatientUpdateState copyWith({
    String? response,
    CustomError? error,
    bool? isLoading,
  }) =>
      PatientUpdateState(
        response: response ?? this.response,
        error: error ?? this.error,
        isLoading: isLoading ?? this.isLoading,
      );
}
