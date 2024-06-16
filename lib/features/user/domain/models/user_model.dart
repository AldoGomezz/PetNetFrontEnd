import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  final int userId;
  final String firstName;
  final String lastName;
  final String email;
  final String clinic;
  final String address;
  final String collegeNumber;
  final String username;
  final bool confirmed;
  final List<dynamic> patients;

  UserModel({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.clinic,
    required this.address,
    required this.collegeNumber,
    required this.username,
    required this.confirmed,
    required this.patients,
  });

  UserModel copyWith({
    int? userId,
    String? firstName,
    String? lastName,
    String? email,
    String? clinic,
    String? address,
    String? collegeNumber,
    String? username,
    bool? confirmed,
    List<dynamic>? patients,
  }) =>
      UserModel(
        userId: userId ?? this.userId,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        email: email ?? this.email,
        clinic: clinic ?? this.clinic,
        address: address ?? this.address,
        collegeNumber: collegeNumber ?? this.collegeNumber,
        username: username ?? this.username,
        confirmed: confirmed ?? this.confirmed,
        patients: patients ?? this.patients,
      );

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        userId: json["user_id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        clinic: json["clinic"],
        address: json["address"],
        collegeNumber: json["college_number"],
        username: json["username"],
        confirmed: json["confirmed"],
        patients: List<dynamic>.from(json["patients"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "clinic": clinic,
        "address": address,
        "college_number": collegeNumber,
        "username": username,
        "confirmed": confirmed,
        "patients": List<dynamic>.from(patients.map((x) => x)),
      };
}
