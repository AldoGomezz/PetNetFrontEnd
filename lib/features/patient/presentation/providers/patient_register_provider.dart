import 'package:pet_net_app/core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_net_app/features/patient/domain/domain.dart';
import 'package:pet_net_app/features/patient/data/datasources/patient_datasource_impl.dart';

//Provider
final patientRegisterProvider =
    StateNotifierProvider<PatientRegisterNotifier, PatientRegisterState>(
  (ref) => PatientRegisterNotifier(
    patientDatasource: PatientDatasourceImpl(),
    keyValueStorageService: DIServices.keyValueStorageService,
    ref: ref,
  ),
);

//Notifier
class PatientRegisterNotifier extends StateNotifier<PatientRegisterState> {
  final PatientDatasourceImpl patientDatasource;
  final KeyValueStorageService keyValueStorageService;
  final Ref ref;

  PatientRegisterNotifier({
    required this.patientDatasource,
    required this.keyValueStorageService,
    required this.ref,
  }) : super(PatientRegisterState());

  void resetResponse() {
    state = state.copyWith(
      error: CustomError(),
      response: "",
    );
  }

  Future<void> register(PatientRegisterRequest patientRegister) async {
    try {
      state = state.copyWith(isLoading: true);
      resetResponse();
      final token = await _getToken();
      final response = await patientDatasource.registerPatient(
        token,
        patientRegister,
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
    state = PatientRegisterState(error: e);
  }

  void _hableGenericError() {
    state = PatientRegisterState(
      error: CustomError(
        type: CustomErrorType.unhandled,
      ),
    );
  }

  void logout() {
    state = PatientRegisterState();
  }
}

//State
class PatientRegisterState {
  final String response;
  final CustomError error;
  final bool isLoading;

  PatientRegisterState({
    this.response = "",
    CustomError? error,
    this.isLoading = false,
  }) : error = error ?? CustomError();

  PatientRegisterState copyWith({
    String? response,
    CustomError? error,
    bool? isLoading,
  }) =>
      PatientRegisterState(
        response: response ?? this.response,
        error: error ?? this.error,
        isLoading: isLoading ?? this.isLoading,
      );
}
