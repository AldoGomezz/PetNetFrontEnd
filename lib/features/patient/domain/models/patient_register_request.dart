import 'dart:typed_data';

class PatientRegisterRequest {
  final int ownerId;
  final String nickname;
  final int age;
  final int weight;
  final Uint8List profilePhoto;
  final String profilePhotoName;

  PatientRegisterRequest({
    required this.ownerId,
    required this.nickname,
    required this.age,
    required this.weight,
    required this.profilePhoto,
    required this.profilePhotoName,
  });

  PatientRegisterRequest copyWith({
    int? ownerId,
    String? nickname,
    int? age,
    int? weight,
    Uint8List? profilePhoto,
    String? profilePhotoName,
  }) =>
      PatientRegisterRequest(
        ownerId: ownerId ?? this.ownerId,
        nickname: nickname ?? this.nickname,
        age: age ?? this.age,
        weight: weight ?? this.weight,
        profilePhoto: profilePhoto ?? this.profilePhoto,
        profilePhotoName: profilePhotoName ?? this.profilePhotoName,
      );

  Map<String, dynamic> toJson() => {
        "owner_id": ownerId,
        "nickname": nickname,
        "age": age,
        "weight": weight,
        "profile_photo": profilePhoto,
      };
}
