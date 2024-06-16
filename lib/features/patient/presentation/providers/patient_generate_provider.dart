import 'package:pet_net_app/core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_net_app/features/patient/domain/domain.dart';
import 'package:pet_net_app/features/patient/data/datasources/patient_datasource_impl.dart';

//Provider
final patientGenerateProvider =
    StateNotifierProvider<PatientGenerateNotifier, PatientGanerateState>(
  (ref) => PatientGenerateNotifier(
    patientDatasource: PatientDatasourceImpl(),
    keyValueStorageService: DIServices.keyValueStorageService,
    ref: ref,
  ),
);

//Notifier
class PatientGenerateNotifier extends StateNotifier<PatientGanerateState> {
  final PatientDatasourceImpl patientDatasource;
  final KeyValueStorageService keyValueStorageService;
  final Ref ref;

  PatientGenerateNotifier({
    required this.patientDatasource,
    required this.keyValueStorageService,
    required this.ref,
  }) : super(PatientGanerateState());

  void resetResponse() {
    state = state.copyWith(
      error: CustomError(),
      response: "",
    );
  }

  Future<void> patientGenerate(PatientGenerateRequest patientGenerate) async {
    try {
      state = state.copyWith(isLoading: true);
      resetResponse();
      final token = await _getToken();
      final response = await patientDatasource.patientGenerate(
        token,
        patientGenerate,
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
    state = PatientGanerateState(error: e);
  }

  void _hableGenericError() {
    state = PatientGanerateState(
      error: CustomError(
        type: CustomErrorType.unhandled,
      ),
    );
  }

  void logout() {
    state = PatientGanerateState();
  }
}

//State
class PatientGanerateState {
  final String response;
  final CustomError error;
  final bool isLoading;

  PatientGanerateState({
    this.response = "",
    CustomError? error,
    this.isLoading = false,
  }) : error = error ?? CustomError();

  PatientGanerateState copyWith({
    String? response,
    CustomError? error,
    bool? isLoading,
  }) =>
      PatientGanerateState(
        response: response ?? this.response,
        error: error ?? this.error,
        isLoading: isLoading ?? this.isLoading,
      );
}
