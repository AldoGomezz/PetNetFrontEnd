import 'dart:convert';

RegisterRequest registerRequestFromJson(String str) =>
    RegisterRequest.fromJson(json.decode(str));

String registerRequestToJson(RegisterRequest data) =>
    json.encode(data.toJson());

class RegisterRequest {
  final String firstName;
  final String lastName;
  final String email;
  final String clinic;
  final String address;
  final String collegeNumber;
  final String username;
  final String password;
  final String confirmPassword;

  RegisterRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.clinic,
    required this.address,
    required this.collegeNumber,
    required this.username,
    required this.password,
    required this.confirmPassword,
  });

  RegisterRequest copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? clinic,
    String? address,
    String? collegeNumber,
    String? username,
    String? password,
    String? confirmPassword,
  }) =>
      RegisterRequest(
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        email: email ?? this.email,
        clinic: clinic ?? this.clinic,
        address: address ?? this.address,
        collegeNumber: collegeNumber ?? this.collegeNumber,
        username: username ?? this.username,
        password: password ?? this.password,
        confirmPassword: confirmPassword ?? this.confirmPassword,
      );

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      RegisterRequest(
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        clinic: json["clinic"],
        address: json["address"],
        collegeNumber: json["college_number"],
        username: json["username"],
        password: json["password"],
        confirmPassword: json["confirm_password"],
      );

  Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "clinic": clinic,
        "address": address,
        "college_number": collegeNumber,
        "username": username,
        "password": password,
        "confirm_password": confirmPassword,
      };
}
