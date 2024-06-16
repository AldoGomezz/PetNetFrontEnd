import 'dart:convert';

OwnerFormRequest ownerRegisterRequestFromJson(String str) =>
    OwnerFormRequest.fromJson(json.decode(str));

String ownerRegisterRequestToJson(OwnerFormRequest data) =>
    json.encode(data.toJson());

class OwnerFormRequest {
  String firstName;
  String lastName;
  String email;
  String phoneNumber;
  String document;

  OwnerFormRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.document,
  });

  OwnerFormRequest copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? document,
  }) =>
      OwnerFormRequest(
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        email: email ?? this.email,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        document: document ?? this.document,
      );

  factory OwnerFormRequest.fromJson(Map<String, dynamic> json) =>
      OwnerFormRequest(
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        phoneNumber: json["phone_number"],
        document: json["document"],
      );

  Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "phone_number": phoneNumber,
        "document": document,
      };
}
