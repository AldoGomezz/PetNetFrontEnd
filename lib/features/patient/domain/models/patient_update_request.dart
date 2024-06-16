import 'dart:convert';

PatientUpdateRequest patientUpdateRequestFromJson(String str) =>
    PatientUpdateRequest.fromJson(json.decode(str));

String patientUpdateRequestToJson(PatientUpdateRequest data) =>
    json.encode(data.toJson());

class PatientUpdateRequest {
  final String nickname;
  final int age;
  final int weight;

  PatientUpdateRequest({
    required this.nickname,
    required this.age,
    required this.weight,
  });

  PatientUpdateRequest copyWith({
    String? nickname,
    int? age,
    int? weight,
  }) =>
      PatientUpdateRequest(
        nickname: nickname ?? this.nickname,
        age: age ?? this.age,
        weight: weight ?? this.weight,
      );

  factory PatientUpdateRequest.fromJson(Map<String, dynamic> json) =>
      PatientUpdateRequest(
        nickname: json["nickname"],
        age: json["age"],
        weight: json["weight"],
      );

  Map<String, dynamic> toJson() => {
        "nickname": nickname,
        "age": age,
        "weight": weight,
      };
}
