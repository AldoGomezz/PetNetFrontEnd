import 'dart:convert';

import 'package:pet_net_app/features/owner/domain/domain.dart';

OwnerUpdateResponse ownerUpdateResponseFromJson(String str) =>
    OwnerUpdateResponse.fromJson(json.decode(str));

String ownerUpdateResponseToJson(OwnerUpdateResponse data) =>
    json.encode(data.toJson());

class OwnerUpdateResponse {
  String? message;
  OwnerModel? owner;

  OwnerUpdateResponse({
    this.message,
    this.owner,
  });

  OwnerUpdateResponse copyWith({
    String? message,
    OwnerModel? owner,
  }) =>
      OwnerUpdateResponse(
        message: message ?? this.message,
        owner: owner ?? this.owner,
      );

  factory OwnerUpdateResponse.fromJson(Map<String, dynamic> json) =>
      OwnerUpdateResponse(
        message: json["message"],
        owner:
            json["owner"] == null ? null : OwnerModel.fromJson(json["owner"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "owner": owner?.toJson(),
      };
}
