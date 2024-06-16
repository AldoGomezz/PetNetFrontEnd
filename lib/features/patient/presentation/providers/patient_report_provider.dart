import 'package:pet_net_app/core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_net_app/features/patient/domain/domain.dart';
import 'package:pet_net_app/features/patient/data/datasources/patient_datasource_impl.dart';

//Provider
final patientReportProvider =
    StateNotifierProvider<PatientReportNotifier, PatientReportState>(
  (ref) => PatientReportNotifier(
    patientDatasource: PatientDatasourceImpl(),
    keyValueStorageService: DIServices.keyValueStorageService,
    ref: ref,
  ),
);

//Notifier
class PatientReportNotifier extends StateNotifier<PatientReportState> {
  final PatientDatasourceImpl patientDatasource;
  final KeyValueStorageService keyValueStorageService;
  final Ref ref;

  PatientReportNotifier({
    required this.patientDatasource,
    required this.keyValueStorageService,
    required this.ref,
  }) : super(PatientReportState());

  void resetResponse() {
    state = state.copyWith(
      error: CustomError(),
      response: "",
    );
  }

  setPdf(PdfModel pdf) {
    state = state.copyWith(pdf: pdf);
  }

  Future<void> getReport(int patientId) async {
    try {
      state = state.copyWith(isLoading: true);
      resetResponse();
      final token = await _getToken();
      final response = await patientDatasource.getReport(token, patientId);

      state = state.copyWith(
        pdf: response,
        response: "Report get successfull",
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
    state = PatientReportState(error: e);
  }

  void _hableGenericError() {
    state = PatientReportState(
      error: CustomError(
        type: CustomErrorType.unhandled,
      ),
    );
  }

  void logout() {
    state = PatientReportState();
  }
}

//State
class PatientReportState {
  final PdfModel? pdf;
  final String response;
  final CustomError error;
  final bool isLoading;

  PatientReportState({
    this.pdf,
    this.response = "",
    CustomError? error,
    this.isLoading = false,
  }) : error = error ?? CustomError();

  PatientReportState copyWith({
    PdfModel? pdf,
    String? response,
    CustomError? error,
    bool? isLoading,
  }) =>
      PatientReportState(
        pdf: pdf ?? this.pdf,
        response: response ?? this.response,
        error: error ?? this.error,
        isLoading: isLoading ?? this.isLoading,
      );
}
