import 'dart:convert';

PredictModel predictModelFromJson(String str) =>
    PredictModel.fromJson(json.decode(str));

String predictModelToJson(PredictModel data) => json.encode(data.toJson());

class PredictModel {
  final String className;
  final double probability;

  PredictModel({
    required this.className,
    required this.probability,
  });

  PredictModel copyWith({
    String? className,
    double? probability,
  }) =>
      PredictModel(
        className: className ?? this.className,
        probability: probability ?? this.probability,
      );

  factory PredictModel.fromJson(Map<String, dynamic> json) => PredictModel(
        className: json["class_name"],
        probability: json["probability"],
      );

  Map<String, dynamic> toJson() => {
        "class_name": className,
        "probability": probability,
      };
}
