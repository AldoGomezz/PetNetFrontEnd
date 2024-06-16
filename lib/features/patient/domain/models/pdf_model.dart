import 'dart:convert';
import 'package:pet_net_app/features/patient/domain/domain.dart';

PdfModel pdfModelFromJson(String str) => PdfModel.fromJson(json.decode(str));

String pdfModelToJson(PdfModel data) => json.encode(data.toJson());

class PdfModel {
  final User user;
  final PatientModel patient;
  final Owner owner;

  PdfModel({
    required this.user,
    required this.patient,
    required this.owner,
  });

  PdfModel copyWith({
    User? user,
    PatientModel? patient,
    Owner? owner,
  }) =>
      PdfModel(
        user: user ?? this.user,
        patient: patient ?? this.patient,
        owner: owner ?? this.owner,
      );

  factory PdfModel.fromJson(Map<String, dynamic> json) => PdfModel(
        user: User.fromJson(json["user"]),
        patient: PatientModel.fromJson(json["patient"]),
        owner: Owner.fromJson(json["owner"]),
      );

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "patient": patient.toJson(),
        "owner": owner.toJson(),
      };
}

class Owner {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String document;

  Owner({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.document,
  });

  Owner copyWith({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? document,
  }) =>
      Owner(
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        document: document ?? this.document,
      );

  factory Owner.fromJson(Map<String, dynamic> json) => Owner(
        firstName: json["first_name"],
        lastName: json["last_name"],
        phoneNumber: json["phone_number"],
        document: json["document"],
      );

  Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "phone_number": phoneNumber,
        "document": document,
      };
}

class User {
  final String firstName;
  final String lastName;
  final String email;
  final String? clinic;
  final String? addres;
  final String collegeNumber;

  User({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.clinic,
    required this.addres,
    required this.collegeNumber,
  });

  User copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? clinic,
    String? addres,
    String? collegeNumber,
  }) =>
      User(
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        email: email ?? this.email,
        clinic: clinic ?? this.clinic,
        addres: addres ?? this.addres,
        collegeNumber: collegeNumber ?? this.collegeNumber,
      );

  factory User.fromJson(Map<String, dynamic> json) => User(
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        clinic: json["clinic"],
        addres: json["addres"],
        collegeNumber: json["college_number"],
      );

  Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "clinic": clinic,
        "addres": addres,
        "college_number": collegeNumber,
      };
}
