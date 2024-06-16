import 'dart:convert';

import 'package:pet_net_app/features/owner/domain/domain.dart';

PatientModel patientModelFromJson(String str) =>
    PatientModel.fromJson(json.decode(str));

String patientModelToJson(PatientModel data) => json.encode(data.toJson());

class PatientModel {
  final int id;
  final String nickname;
  final int age;
  final DateTime dateOfRegister;
  final double weight;
  final String profilePhoto;
  final int userId;
  final int ownerId;
  final List<Photo> photos;

  PatientModel({
    required this.id,
    required this.nickname,
    required this.age,
    required this.dateOfRegister,
    required this.weight,
    required this.profilePhoto,
    required this.userId,
    required this.ownerId,
    required this.photos,
  });

  PatientModel copyWith({
    int? id,
    String? nickname,
    int? age,
    DateTime? dateOfRegister,
    double? weight,
    String? profilePhoto,
    int? userId,
    int? ownerId,
    List<Photo>? photos,
  }) =>
      PatientModel(
        id: id ?? this.id,
        nickname: nickname ?? this.nickname,
        age: age ?? this.age,
        dateOfRegister: dateOfRegister ?? this.dateOfRegister,
        weight: weight ?? this.weight,
        profilePhoto: profilePhoto ?? this.profilePhoto,
        userId: userId ?? this.userId,
        ownerId: ownerId ?? this.ownerId,
        photos: photos ?? this.photos,
      );

  factory PatientModel.fromJson(Map<String, dynamic> json) => PatientModel(
        id: json["id"],
        nickname: json["nickname"],
        age: json["age"],
        dateOfRegister: DateTime.parse(json["date_of_register"]),
        weight: json["weight"],
        profilePhoto: json["profile_photo"],
        userId: json["user_id"],
        ownerId: json["owner_id"],
        photos: List<Photo>.from(json["photos"].map((x) => Photo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nickname": nickname,
        "age": age,
        "date_of_register": dateOfRegister.toIso8601String(),
        "weight": weight,
        "profile_photo": profilePhoto,
        "user_id": userId,
        "owner_id": ownerId,
        "photos": List<dynamic>.from(photos.map((x) => x.toJson())),
      };
}
