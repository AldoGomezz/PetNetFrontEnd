import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_net_app/core/core.dart';
import 'package:pet_net_app/features/patient/presentation/presentation.dart';
import 'package:pet_net_app/features/predict/presentation/presentation.dart';

class PredictScreen extends ConsumerWidget {
  final XFile image;
  const PredictScreen({super.key, required this.image});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _listenToPredictError(context, ref);

    final size = MediaQuery.of(context).size;
    final predictPv = ref.watch(predictProvider);
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
            child: predictPv.predict != null
                ? Column(
                    children: [
                      Text(
                        "Su mascota tiene",
                        style: getTitleBoldStyle(context),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        predictPv.predict!.className.toUpperCase(),
                        style:
                            getHeaderStyle(context).copyWith(color: Colors.red),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "con una probabilidad de ${(predictPv.predict!.probability * 100).toStringAsFixed(2)}%",
                        style: getSubtitleBoldStyle(context),
                      ),
                      const SizedBox(height: 15),
                      CustomFilledButton(
                        text: "Guardar",
                        style: getSmallSubtitleBoldStyle(context).copyWith(
                          color: Colors.white,
                        ),
                        onPressed: () {
                          ref
                              .read(patientGenerateFormProvider.notifier)
                              .onClassNameChanged(predictPv.predict!.className);
                          ref
                              .read(patientGenerateFormProvider.notifier)
                              .onProbabilityChanged(
                                predictPv.predict!.probability
                                    .toStringAsFixed(2),
                              );

                          //Imagen a bytes
                          final bytes = File(image.path).readAsBytesSync();
                          ref
                              .read(patientGenerateFormProvider.notifier)
                              .onAnalyzedPhotoChanged(bytes);

                          ref
                              .read(patientGenerateFormProvider.notifier)
                              .onAnalyzedPhotoNameChanged(
                                  image.path.split("/").last);

                          context.push("/patient-generate-form");
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
                : predictPv.predict != null
                    ? Container()
                    : CustomFilledButton(
                        text: "Analizar",
                        style: getSmallSubtitleBoldStyle(context).copyWith(
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          ref.read(predictProvider.notifier).logout();
                          final bytes = await image.readAsBytes();
                          ref
                              .read(predictProvider.notifier)
                              .predict(bytes, image.path.split("/").last);
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
      predictProvider.select((value) => value.error),
      (previous, next) {
        String messageError = next.message != null
            ? next.message!
            : getErrorMessage(next, context);
        if (next.type != null) {
          if (next.type == CustomErrorType.unauthorized) {
            ResponseHandler.handle401Response(context, ref, () {
              ref.read(predictProvider.notifier).resetResponse();
            });
          }
          CustomDialogs().showSnackbar(context, messageError);
          ref.read(predictProvider.notifier).resetResponse();
        }
      },
    );
  }
}
