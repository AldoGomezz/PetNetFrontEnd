import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_net_app/core/core.dart';
import 'package:pet_net_app/features/patient/presentation/presentation.dart';

class PredictPatientScreen extends ConsumerWidget {
  final XFile image;
  const PredictPatientScreen({super.key, required this.image});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _listenToPredictError(context, ref);

    final size = MediaQuery.of(context).size;
    final predictPv = ref.watch(patientPredictProvider);
    final patient = ref.watch(patientGetProvider);
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
            child: Image.file(
              File(image.path),
              height: size.height * 0.5,
            ),
          ),
          //Resultados
          Positioned(
            top: size.height * 0.7,
            left: size.width * 0.1,
            right: size.width * 0.1,
            child: predictPv.photo != null
                ? Column(
                    children: [
                      Text(
                        "Su mascota tiene",
                        style: getTitleBoldStyle(context),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        predictPv.photo!.predictedClass?.toUpperCase() ??
                            "no-predicted-class",
                        style:
                            getHeaderStyle(context).copyWith(color: Colors.red),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "con una probabilidad de ${(predictPv.photo!.probability ?? "0" * 100)}%",
                        style: getSubtitleBoldStyle(context),
                      ),
                      const SizedBox(height: 15),
                      CustomFilledButton(
                        text: "Volver",
                        style: getSmallSubtitleBoldStyle(context).copyWith(
                          color: Colors.white,
                        ),
                        onPressed: () {
                          context.pop();
                        },
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
          //Botón de predecir
          Positioned(
            bottom: size.height * 0.1,
            left: size.width * 0.1,
            right: size.width * 0.1,
            child: predictPv.isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : predictPv.photo != null
                    ? Container()
                    : CustomFilledButton(
                        text: "Analizar",
                        style: getSmallSubtitleBoldStyle(context).copyWith(
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          ref.read(patientPredictProvider.notifier).logout();
                          final bytes = await image.readAsBytes();
                          await ref
                              .read(patientPredictProvider.notifier)
                              .predict(
                                patient.patient!.id,
                                bytes,
                                image.path.split("/").last,
                                "",
                              );
                          await ref
                              .read(patientGetProvider.notifier)
                              .get(patient.patient!.id);
                          /* ref.read(predictProvider.notifier).logout();
                          final bytes = await image.readAsBytes();
                          ref
                              .read(patientPredictProvider.notifier)
                              .predict(bytes, image.path.split("/").last); */
                        },
                      ),
          ),
        ],
      ),
    );
  }

  void _listenToPredictError(
    BuildContext context,
    WidgetRef ref,
  ) {
    ref.listen(
      patientPredictProvider.select((value) => value.error),
      (previous, next) {
        String messageError = next.message != null
            ? next.message!
            : getErrorMessage(next, context);
        if (next.type != null) {
          if (next.type == CustomErrorType.unauthorized) {
            ResponseHandler.handle401Response(context, ref, () {
              ref.read(patientPredictProvider.notifier).resetResponse();
            });
          }
          CustomDialogs().showSnackbar(context, messageError);
          ref.read(patientPredictProvider.notifier).resetResponse();
        }
      },
    );
  }
}
