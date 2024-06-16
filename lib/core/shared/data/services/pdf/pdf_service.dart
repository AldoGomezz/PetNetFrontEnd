import 'dart:io';

import 'package:pet_net_app/core/core.dart';
import 'package:pet_net_app/features/patient/domain/domain.dart';

abstract class PdfService {
  Future<File> generatePdf(
    PdfModel invoice,
    FileService fileService,
    int indexPhoto,
  );
}
