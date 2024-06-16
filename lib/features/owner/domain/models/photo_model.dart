class Photo {
  final int id;
  final String photo;
  final String filename;
  final DateTime dateOfRegister;
  final int patientId;
  final String? description;
  final String? probability;
  final String? predictedClass;

  Photo({
    required this.id,
    required this.photo,
    required this.filename,
    required this.dateOfRegister,
    required this.patientId,
    this.description,
    this.probability,
    this.predictedClass,
  });

  Photo copyWith({
    int? id,
    String? photo,
    String? filename,
    DateTime? dateOfRegister,
    int? patientId,
    String? description,
    String? probability,
    String? predictedClass,
  }) =>
      Photo(
        id: id ?? this.id,
        photo: photo ?? this.photo,
        filename: filename ?? this.filename,
        dateOfRegister: dateOfRegister ?? this.dateOfRegister,
        patientId: patientId ?? this.patientId,
        description: description ?? this.description,
        probability: probability ?? this.probability,
        predictedClass: predictedClass ?? this.predictedClass,
      );

  factory Photo.fromJson(Map<String, dynamic> json) => Photo(
        id: json["id"],
        photo: json["photo"],
        filename: json["filename"],
        dateOfRegister: DateTime.parse(json["date_of_register"]),
        patientId: json["patient_id"],
        description: json["description"],
        probability: json["probability"],
        predictedClass: json["predicted_class"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "photo": photo,
        "filename": filename,
        "date_of_register": dateOfRegister.toIso8601String(),
        "patient_id": patientId,
        "description": description,
        "probability": probability,
        "predicted_class": predictedClass,
      };
}
