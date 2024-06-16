import 'package:pet_net_app/features/patient/domain/domain.dart';

class OwnerModel {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? document;
  List<PatientModel>? patients;

  OwnerModel({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.document,
    this.patients,
  });

  OwnerModel copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? document,
    List<PatientModel>? patients,
  }) =>
      OwnerModel(
        id: id ?? this.id,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        email: email ?? this.email,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        document: document ?? this.document,
        patients: patients ?? this.patients,
      );

  factory OwnerModel.fromJson(Map<String, dynamic> json) => OwnerModel(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        phoneNumber: json["phone_number"],
        document: json["document"],
        patients: json["patients"] == null
            ? []
            : List<PatientModel>.from(
                json["patients"]!.map((x) => PatientModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "phone_number": phoneNumber,
        "document": document,
        "patients": patients == null
            ? []
            : List<dynamic>.from(patients!.map((x) => x.toJson())),
      };
}
