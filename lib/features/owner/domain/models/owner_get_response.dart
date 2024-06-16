import 'dart:convert';

import 'owner_model.dart';

OwnerGetResponse ownerGetResponseFromJson(String str) =>
    OwnerGetResponse.fromJson(json.decode(str));

String ownerGetResponseToJson(OwnerGetResponse data) =>
    json.encode(data.toJson());

class OwnerGetResponse {
  final String message;
  final OwnerModel owner;

  OwnerGetResponse({
    required this.message,
    required this.owner,
  });

  OwnerGetResponse copyWith({
    String? message,
    OwnerModel? owner,
  }) =>
      OwnerGetResponse(
        message: message ?? this.message,
        owner: owner ?? this.owner,
      );

  factory OwnerGetResponse.fromJson(Map<String, dynamic> json) =>
      OwnerGetResponse(
        message: json["message"],
        owner: OwnerModel.fromJson(json["owner"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "owner": owner.toJson(),
      };
}
