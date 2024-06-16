import 'dart:convert';

UpdateInfoRequest updateInfoRequestFromJson(String str) =>
    UpdateInfoRequest.fromJson(json.decode(str));

String updateInfoRequestToJson(UpdateInfoRequest data) =>
    json.encode(data.toJson());

class UpdateInfoRequest {
  final String firstName;
  final String lastName;
  final String clinic;
  final String address;
  final String collegeNumber;
  final String username;

  UpdateInfoRequest({
    required this.firstName,
    required this.lastName,
    required this.clinic,
    required this.address,
    required this.collegeNumber,
    required this.username,
  });

  UpdateInfoRequest copyWith({
    String? firstName,
    String? lastName,
    String? clinic,
    String? address,
    String? collegeNumber,
    String? username,
  }) =>
      UpdateInfoRequest(
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        clinic: clinic ?? this.clinic,
        address: address ?? this.address,
        collegeNumber: collegeNumber ?? this.collegeNumber,
        username: username ?? this.username,
      );

  factory UpdateInfoRequest.fromJson(Map<String, dynamic> json) =>
      UpdateInfoRequest(
        firstName: json["first_name"],
        lastName: json["last_name"],
        clinic: json["clinic"],
        address: json["address"],
        collegeNumber: json["college_number"],
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "clinic": clinic,
        "address": address,
        "college_number": collegeNumber,
        "username": username,
      };
}
