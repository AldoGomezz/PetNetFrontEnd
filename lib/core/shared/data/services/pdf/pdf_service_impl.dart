import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pet_net_app/core/core.dart';
import 'package:pet_net_app/features/patient/domain/domain.dart';

/// Implementation of the PdfService interface that generates a PDF file for an invoice.
/// It uses the invoice data and a FileService to save the generated PDF file.
class PdfServiceImpl extends PdfService {
  @override
  Future<File> generatePdf(
    PdfModel invoice,
    FileService fileService,
    int indexPhoto,
  ) async {
    try {
      Dio dio = Dio();
      final response = await dio.get<Uint8List>(
        invoice.patient.photos[indexPhoto].photo,
        options: Options(
          responseType: ResponseType.bytes,
        ),
      );

      final Uint8List responseBytesPhoto = response.data!;
      Uint8List imageData = (await rootBundle.load('assets/logo/pet_net.png'))
          .buffer
          .asUint8List();

      final pdf = _buildPdf(
        invoice,
        responseBytesPhoto,
        imageData,
        indexPhoto,
      );
      Uint8List bytes = await pdf.save();
      String fileName =
          _generateUniqueFileName("reporte_${invoice.patient.nickname}");
      File file = await fileService.saveFile(bytes, fileName);

      return file;
    } catch (e) {
      throw CustomError(message: "Error al generar pdf");
    }
  }
}

pw.Document _buildPdf(
  PdfModel invoice,
  Uint8List photo,
  Uint8List imageData,
  int indexPhoto,
) {
  const double fontTitle = 15;
  const double fontSubtitle = 11;
  final pdf = pw.Document(
    theme: pw.ThemeData.withFont(
        // base: pw.Font.ttf(await rootBundle.load("fonts/Abel-Regular.ttf")),
        ),
  );

  Color colorPrimary = const Color(0xFFE73838);
  Color colorTirtiary = const Color(0xFF999999);

  PdfColor pdfColorPrimary = PdfColor(
    colorPrimary.red / 255.0,
    colorPrimary.green / 255.0,
    colorPrimary.blue / 255.0,
  );

  PdfColor pdfColorTirtiary = PdfColor(
    colorTirtiary.red / 255.0,
    colorTirtiary.green / 255.0,
    colorTirtiary.blue / 255.0,
  );

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            _buildHeader(
              invoice,
              pdfColorPrimary,
              fontTitle,
              fontSubtitle,
              imageData,
            ),
            pw.SizedBox(height: 25),
            _buildSubHeaders(
              invoice,
              pdfColorPrimary,
              fontTitle,
              fontSubtitle,
            ),
            pw.SizedBox(height: 35),
            _buildInfoOwnerAndPatient(
              invoice,
              pdfColorPrimary,
              pdfColorTirtiary,
              fontTitle,
              fontSubtitle,
            ),
            pw.SizedBox(height: 35),
            _buildResult(
              invoice,
              indexPhoto,
              photo,
              pdfColorPrimary,
              pdfColorTirtiary,
              fontTitle,
              fontSubtitle,
            ),
          ],
        );
      },
    ),
  );

  return pdf;
}

pw.Widget _buildHeader(
  PdfModel invoice,
  PdfColor pdfColorPrimary,
  double fontTitle,
  double fontSubtitle,
  Uint8List imageData,
) {
  // Obtener la fecha y hora actual
  DateTime now = DateTime.now();
  // Formatear la fecha y hora utilizando el paquete intl
  String formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(now);

  return pw.Stack(
    children: [
      pw.Align(
        alignment: pw.Alignment.center,
        child: pw.Image(
          pw.MemoryImage(imageData),
          width: 60,
          height: 60,
        ),
      ),
      pw.Align(
        alignment: pw.Alignment.topRight,
        child: pw.Container(
          padding: const pw.EdgeInsets.all(10),
          decoration: pw.BoxDecoration(
            color: pdfColorPrimary,
            borderRadius: pw.BorderRadius.circular(10),
          ),
          child: pw.Text(
            "Fecha: $formattedDate",
            style: pw.TextStyle(
              fontSize: fontSubtitle,
            ),
          ),
        ),
      ),
    ],
  );
}

pw.Widget _buildSubHeaders(
  PdfModel invoice,
  PdfColor pdfColorPrimary,
  double fontTitle,
  double fontSubtitle,
) {
  return pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    children: [
      pw.Container(
        padding: const pw.EdgeInsets.all(10),
        decoration: pw.BoxDecoration(
          color: pdfColorPrimary,
          borderRadius: pw.BorderRadius.circular(10),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.RichText(
              text: pw.TextSpan(
                text: "Nombre Vet: ",
                style: pw.TextStyle(
                  fontSize: fontSubtitle,
                  fontWeight: pw.FontWeight.bold,
                ),
                children: [
                  pw.TextSpan(
                    text:
                        "${invoice.user.firstName.toUpperCase()} ${invoice.user.lastName.toUpperCase()}",
                    style: pw.TextStyle(
                      fontSize: fontSubtitle,
                      fontWeight: pw.FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 5),
            pw.RichText(
              text: pw.TextSpan(
                text: "Nro Coleg.: ",
                style: pw.TextStyle(
                  fontSize: fontSubtitle,
                  fontWeight: pw.FontWeight.bold,
                ),
                children: [
                  pw.TextSpan(
                    text: invoice.user.collegeNumber,
                    style: pw.TextStyle(
                      fontSize: fontSubtitle,
                      fontWeight: pw.FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      pw.Container(
        padding: const pw.EdgeInsets.all(10),
        decoration: pw.BoxDecoration(
          color: pdfColorPrimary,
          borderRadius: pw.BorderRadius.circular(10),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.RichText(
              text: pw.TextSpan(
                text: "Clínica: ",
                style: pw.TextStyle(
                  fontSize: fontSubtitle,
                  fontWeight: pw.FontWeight.bold,
                ),
                children: [
                  pw.TextSpan(
                    text: invoice.user.clinic,
                    style: pw.TextStyle(
                      fontSize: fontSubtitle,
                      fontWeight: pw.FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 5),
            pw.RichText(
              text: pw.TextSpan(
                text: "Dirección: ",
                style: pw.TextStyle(
                  fontSize: fontSubtitle,
                  fontWeight: pw.FontWeight.bold,
                ),
                children: [
                  pw.TextSpan(
                    text: invoice.user.addres,
                    style: pw.TextStyle(
                      fontSize: fontSubtitle,
                      fontWeight: pw.FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

pw.Widget _buildInfoOwnerAndPatient(
  PdfModel invoice,
  PdfColor pdfColorPrimary,
  PdfColor pdfColorTertiary,
  double fontTitle,
  double fontSubtitle,
) {
  return pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    children: [
      pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            "Dueño",
            style: pw.TextStyle(
              fontSize: fontSubtitle,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            children: [
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  color: pdfColorPrimary,
                  borderRadius: pw.BorderRadius.circular(10),
                ),
                child: pw.Text(
                  "Nombre",
                  style: pw.TextStyle(
                    fontSize: fontSubtitle,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(width: 5),
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  color: pdfColorTertiary,
                  borderRadius: pw.BorderRadius.circular(10),
                ),
                child: pw.Text(
                  "${invoice.owner.firstName} ${invoice.owner.lastName}",
                  style: pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: fontSubtitle,
                    fontWeight: pw.FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            children: [
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  color: pdfColorPrimary,
                  borderRadius: pw.BorderRadius.circular(10),
                ),
                child: pw.Text(
                  "DNI",
                  style: pw.TextStyle(
                    fontSize: fontSubtitle,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(width: 5),
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  color: pdfColorTertiary,
                  borderRadius: pw.BorderRadius.circular(10),
                ),
                child: pw.Text(
                  invoice.owner.document,
                  style: pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: fontSubtitle,
                    fontWeight: pw.FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            children: [
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  color: pdfColorPrimary,
                  borderRadius: pw.BorderRadius.circular(10),
                ),
                child: pw.Text(
                  "Teléfono",
                  style: pw.TextStyle(
                    fontSize: fontSubtitle,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(width: 5),
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  color: pdfColorTertiary,
                  borderRadius: pw.BorderRadius.circular(10),
                ),
                child: pw.Text(
                  invoice.owner.phoneNumber,
                  style: pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: fontSubtitle,
                    fontWeight: pw.FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      //Paciente
      pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            "Paciente",
            style: pw.TextStyle(
              fontSize: fontSubtitle,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            children: [
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  color: pdfColorPrimary,
                  borderRadius: pw.BorderRadius.circular(10),
                ),
                child: pw.Text(
                  "Nombre",
                  style: pw.TextStyle(
                    fontSize: fontSubtitle,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(width: 5),
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  color: pdfColorTertiary,
                  borderRadius: pw.BorderRadius.circular(10),
                ),
                child: pw.Text(
                  invoice.patient.nickname,
                  style: pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: fontSubtitle,
                    fontWeight: pw.FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            children: [
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  color: pdfColorPrimary,
                  borderRadius: pw.BorderRadius.circular(10),
                ),
                child: pw.Text(
                  "Edad",
                  style: pw.TextStyle(
                    fontSize: fontSubtitle,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(width: 5),
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  color: pdfColorTertiary,
                  borderRadius: pw.BorderRadius.circular(10),
                ),
                child: pw.Text(
                  invoice.patient.age.toString(),
                  style: pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: fontSubtitle,
                    fontWeight: pw.FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            children: [
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  color: pdfColorPrimary,
                  borderRadius: pw.BorderRadius.circular(10),
                ),
                child: pw.Text(
                  "Peso",
                  style: pw.TextStyle(
                    fontSize: fontSubtitle,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(width: 5),
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  color: pdfColorTertiary,
                  borderRadius: pw.BorderRadius.circular(10),
                ),
                child: pw.Text(
                  invoice.patient.weight.toString(),
                  style: pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: fontSubtitle,
                    fontWeight: pw.FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

pw.Widget _buildResult(
  PdfModel invoice,
  int indexPhoto,
  Uint8List photo,
  PdfColor pdfColorPrimary,
  PdfColor pdfColorTertiary,
  double fontTitle,
  double fontSubtitle,
) {
  return pw.Center(
    child: pw.Container(
      padding: const pw.EdgeInsets.all(30),
      decoration: pw.BoxDecoration(
        color: pdfColorTertiary,
        borderRadius: pw.BorderRadius.circular(10),
      ),
      child: pw.Column(
        children: [
          //IMAGEN
          pw.Image(
            pw.MemoryImage(photo),
            width: 250,
            height: 250,
          ),
          pw.SizedBox(height: 20),
          //RESULTADO
          pw.Text(
            "Su mascota tiene",
            style: pw.TextStyle(
              fontSize: fontSubtitle,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            invoice.patient.photos[indexPhoto].predictedClass?.toUpperCase() ??
                "no-class",
            style: pw.TextStyle(
              color: PdfColors.red,
              fontSize: fontTitle,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            "con una probabilidad de ${(double.parse(invoice.patient.photos[indexPhoto].probability ?? '0') * 100).toStringAsFixed(2)}%",
            style: pw.TextStyle(
              fontSize: fontSubtitle,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}

String _generateUniqueFileName(String baseName) {
  DateTime now = DateTime.now();
  String timestamp = now.microsecondsSinceEpoch.toString();
  return "${baseName}_$timestamp";
}
