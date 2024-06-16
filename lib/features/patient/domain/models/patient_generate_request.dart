import 'dart:convert';
import 'dart:typed_data';

/* PatientGenerateRequest patientGenerateRequestFromJson(String str) =>
    PatientGenerateRequest.fromJson(json.decode(str)); */

String patientGenerateRequestToJson(PatientGenerateRequest data) =>
    json.encode(data.toJson());

class PatientGenerateRequest {
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String document;
  final String nickname;
  final int age;
  final int weight;
  final Uint8List profilePhoto;
  final String profilePhotoName;
  final Uint8List analyzedPhoto;
  final String analyzedPhotoName;
  final String description;
  final String className;
  final String probability;

  PatientGenerateRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.document,
    required this.nickname,
    required this.age,
    required this.weight,
    required this.profilePhoto,
    required this.profilePhotoName,
    required this.analyzedPhoto,
    required this.analyzedPhotoName,
    required this.description,
    required this.className,
    required this.probability,
  });

  PatientGenerateRequest copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? document,
    String? nickname,
    int? age,
    int? weight,
    Uint8List? profilePhoto,
    String? profilePhotoName,
    Uint8List? analyzedPhoto,
    String? analyzedPhotoName,
    String? description,
    String? className,
    String? probability,
  }) =>
      PatientGenerateRequest(
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        email: email ?? this.email,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        document: document ?? this.document,
        nickname: nickname ?? this.nickname,
        age: age ?? this.age,
        weight: weight ?? this.weight,
        profilePhoto: profilePhoto ?? this.profilePhoto,
        profilePhotoName: profilePhotoName ?? this.profilePhotoName,
        analyzedPhoto: analyzedPhoto ?? this.analyzedPhoto,
        analyzedPhotoName: analyzedPhotoName ?? this.analyzedPhotoName,
        description: description ?? this.description,
        className: className ?? this.className,
        probability: probability ?? this.probability,
      );

  /* factory PatientGenerateRequest.fromJson(Map<String, dynamic> json) =>
      PatientGenerateRequest(
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        phoneNumber: json["phone_number"],
        document: json["document"],
        nickname: json["nickname"],
        age: json["age"],
        weight: json["weight"],
        profilePhoto: json["profile_photo"],
        analyzedPhoto: json["analyzed_photo"],
        description: json["description"],
        className: json["className"],
        probability: json["probability"],
      ); */

  Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "phone_number": phoneNumber,
        "document": document,
        "nickname": nickname,
        "age": age,
        "weight": weight,
        "profile_photo": profilePhoto,
        "analyzed_photo": analyzedPhoto,
        "description": description,
        "class_name": className,
        "probability": probability,
      };
}
