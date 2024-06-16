import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_net_app/core/core.dart';
import 'package:pet_net_app/features/owner/domain/domain.dart';
import 'package:pet_net_app/features/patient/presentation/providers/patient_report_provider.dart';

class PatientResultScreen extends ConsumerWidget {
  final PatientResultScreenArguments patientResult;
  const PatientResultScreen({super.key, required this.patientResult});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final patientReportPv = ref.watch(patientReportProvider);

    _listenToReportError(context, ref);

    return Scaffold(
      body: Stack(
        children: [
          //Background
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: BackgroundWidget(),
          ),
          //Botón de regresar
          Positioned(
            top: size.height * 0.05,
            left: size.width * 0.02,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          //Imagen
          Positioned(
            top: size.height * 0.15,
            left: size.width * 0.1,
            right: size.width * 0.1,
            child: CachedNetworkImage(
              imageUrl:
                  "${patientResult.photo.photo}?v=${DateTime.now().millisecondsSinceEpoch}",
              height: size.height * 0.5,
              fit: BoxFit.cover,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Center(
                child: SizedBox(
                  height: size.height * 0.1,
                  width: size.height * 0.1,
                  child: CircularProgressIndicator(
                    value: downloadProgress.progress,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          //Resultados
          Positioned(
            top: size.height * 0.7,
            left: size.width * 0.1,
            right: size.width * 0.1,
            child: Column(
              children: [
                Text(
                  "Su mascota tiene",
                  style: getTitleBoldStyle(context),
                ),
                const SizedBox(height: 10),
                Text(
                  patientResult.photo.predictedClass?.toUpperCase() ??
                      "no-class",
                  style: getHeaderStyle(context).copyWith(color: Colors.red),
                ),
                const SizedBox(height: 5),
                Text(
                  "con una probabilidad de ${(double.parse(patientResult.photo.probability ?? '0') * 100).toStringAsFixed(2)}%",
                  style: getSubtitleBoldStyle(context),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    patientReportPv.isLoading
                        ? const CircularProgressIndicator(
                            strokeWidth: 2,
                          )
                        : CustomFilledButton(
                            text: "Generar reporte",
                            style: getSmallSubtitleBoldStyle(context).copyWith(
                              color: Colors.white,
                            ),
                            onPressed: () async {
                              await ref
                                  .read(patientReportProvider.notifier)
                                  .getReport(patientResult.patientId);

                              final pdfService = PdfServiceImpl();
                              final fileService = FileServiceImpl();

                              final patientReportPv =
                                  ref.read(patientReportProvider);

                              final pdf = await pdfService.generatePdf(
                                patientReportPv.pdf!,
                                fileService,
                                patientResult.indexPhoto,
                              );
                              await fileService.openFile(pdf);
                            },
                          ),
                    CustomFilledButton(
                      text: "Volver",
                      style: getSmallSubtitleBoldStyle(context).copyWith(
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _listenToReportError(
    BuildContext context,
    WidgetRef ref,
  ) {
    ref.listen(
      patientReportProvider.select((value) => value.error),
      (previous, next) {
        String messageError = next.message != null
            ? next.message!
            : getErrorMessage(next, context);
        if (next.type != null) {
          if (next.type == CustomErrorType.unauthorized &&
              next.message == "Token is invalid!") {
            ResponseHandler.handle401Response(context, ref, () {
              ref.read(patientReportProvider.notifier).resetResponse();
            });
          }
          CustomDialogs().showSnackbar(context, messageError);
          ref.read(patientReportProvider.notifier).resetResponse();
        }
      },
    );
  }
}

class PatientResultScreenArguments {
  final int patientId;
  final int indexPhoto;
  final Photo photo;
  const PatientResultScreenArguments({
    required this.photo,
    required this.indexPhoto,
    required this.patientId,
  });
}
