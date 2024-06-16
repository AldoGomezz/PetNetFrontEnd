import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:pet_net_app/core/core.dart';
import 'package:pet_net_app/features/owner/domain/domain.dart';
import 'package:pet_net_app/features/patient/domain/domain.dart';

class PatientDatasourceImpl {
  final dio = Dio(BaseOptions(baseUrl: Environment.apiRest));

  Future<List<PatientModel>> getPatients(String token) async {
    try {
      dio.options.headers["Authorization"] = token;
      final response = await dio.get("/patients/search?s=*");
      final patients = response.data as List;
      return patients.map((e) => PatientModel.fromJson(e)).toList();
    } catch (e) {
      throw handleError(e);
    }
  }

  Future<PatientModel> getPatient(String token, int patientId) async {
    try {
      dio.options.headers["Authorization"] = token;
      final response = await dio.get("/patients/information/$patientId");
      return PatientModel.fromJson(response.data);
    } catch (e) {
      throw handleError(e);
    }
  }

  Future<List<PatientModel>> searchPatients(String token, String query) async {
    try {
      dio.options.headers["Authorization"] = token;
      final response = await dio.get("/patients/search?s=$query");
      final patients = response.data as List;
      return patients.map((e) => PatientModel.fromJson(e)).toList();
    } catch (e) {
      throw handleError(e);
    }
  }

  Future<Photo> predicPatient(
    String token,
    int patientId,
    Uint8List profilePhoto,
    String profilePhotoName,
    String? description,
  ) async {
    try {
      dio.options.headers["Authorization"] = token;

      final formData = FormData.fromMap({
        "patient_id": patientId,
        "photo": MultipartFile.fromBytes(
          profilePhoto,
          filename: profilePhotoName,
        ),
      });

      final response = await dio.post(
        "/patients/collection/photos/add",
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
        ),
      );

      return Photo.fromJson(response.data["photo"]);
    } catch (e) {
      throw handleError(e);
    }
  }

  Future<String> updatePatient(
    String token,
    PatientUpdateRequest patientUpdate,
    int patientId,
  ) async {
    try {
      dio.options.headers["Authorization"] = token;

      await dio.put(
        "/patients/update/information/$patientId",
        data: patientUpdate.toJson(),
      );

      return "Patient updated successfully";
    } catch (e) {
      throw handleError(e);
    }
  }

  Future<String> updateImagePatient(
    String token,
    int patientId,
    Uint8List profilePhoto,
    String profilePhotoName,
  ) async {
    try {
      dio.options.headers["Authorization"] = token;

      final formData = FormData.fromMap({
        "profile_photo": MultipartFile.fromBytes(
          profilePhoto,
          filename: profilePhotoName,
        ),
      });

      await dio.put(
        "/patients/update/profile_photo/$patientId",
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
        ),
      );

      return "Patient image updated successfully";
    } catch (e) {
      throw handleError(e);
    }
  }

  Future<String> patientGenerate(
      String token, PatientGenerateRequest patientGenerate) async {
    try {
      dio.options.headers["Authorization"] = token;

      final formData = FormData.fromMap({
        "first_name": patientGenerate.firstName,
        "last_name": patientGenerate.lastName,
        "email": patientGenerate.email,
        "phone_number": patientGenerate.phoneNumber,
        "document": patientGenerate.document,
        "nickname": patientGenerate.nickname,
        "age": patientGenerate.age,
        "weight": patientGenerate.weight,
        "profile_photo": MultipartFile.fromBytes(
          patientGenerate.profilePhoto,
          filename: patientGenerate.profilePhotoName,
        ),
        "analyzed_photo": MultipartFile.fromBytes(
          patientGenerate.analyzedPhoto,
          filename: patientGenerate.analyzedPhotoName,
        ),
        "description": patientGenerate.description,
        "class_name": patientGenerate.className,
        "probability": patientGenerate.probability,
      });

      final response = await dio.post(
        "/patients/generate",
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
        ),
      );
      return response.data["message"];
    } catch (e) {
      throw handleError(e);
    }
  }

  Future<String> registerPatient(
    String token,
    PatientRegisterRequest patientRegister,
  ) async {
    try {
      dio.options.headers["Authorization"] = token;

      final formData = FormData.fromMap({
        "owner_id": patientRegister.ownerId,
        "nickname": patientRegister.nickname,
        "age": patientRegister.age,
        "weight": patientRegister.weight,
        "profile_photo": MultipartFile.fromBytes(
          patientRegister.profilePhoto,
          filename: patientRegister.profilePhotoName,
        ),
      });

      final response = await dio.post(
        "/patients/register",
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
        ),
      );

      return response.data["message"];
    } catch (e) {
      throw handleError(e);
    }
  }

  Future<PdfModel> getReport(String token, int patientId) async {
    try {
      dio.options.headers["Authorization"] = token;
      final response = await dio.get("/patients/generate/pdf/$patientId");
      return PdfModel.fromJson(response.data);
    } catch (e) {
      throw handleError(e);
    }
  }
}
