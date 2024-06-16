import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_net_app/core/core.dart';
import 'package:pet_net_app/features/owner/domain/domain.dart';
import 'package:pet_net_app/features/patient/presentation/presentation.dart';

class PatientInfoContent extends ConsumerStatefulWidget {
  final int patientId;
  const PatientInfoContent({super.key, required this.patientId});

  @override
  PatientInfoContentState createState() => PatientInfoContentState();
}

class PatientInfoContentState extends ConsumerState<PatientInfoContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(patientGetProvider.notifier).get(widget.patientId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Titulo
            Center(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  "Mascota Información",
                  style: getTitleBoldStyle(context),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: size.height * 0.05),
            //Container Patient
            _buildBody(widget.patientId, ref.watch(patientGetProvider), ref),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(
    int patientId,
    PatientGetState state,
    WidgetRef ref,
  ) {
    if (state.isLoading) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    } else if (state.error.type != null) {
      return RetryWidget(
        errorMessage: state.error.message != null
            ? state.error.message!
            : getErrorMessage(state.error, context),
        onPressed: () {
          ref.read(patientGetProvider.notifier).get(patientId);
        },
      );
    } else if (state.patient != null) {
      return const PatientInfoBody();
    } else {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        child: const Center(
          child: Text("No se encontró la mascota"),
        ),
      );
    }
  }
}

class PatientInfoBody extends ConsumerWidget {
  const PatientInfoBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;
    final patient = ref.watch(patientGetProvider).patient!;
    //print(patient.profilePhoto);

    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
          decoration: BoxDecoration(
            color: colorScheme.tertiary,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.02),
              //Imagen
              Center(
                  child: CachedNetworkImage(
                imageUrl:
                    "${patient.profilePhoto}?v=${DateTime.now().millisecondsSinceEpoch}",
                height: size.height * 0.15,
                fit: BoxFit.cover,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Center(
                  child: SizedBox(
                    width: 50, // Adjust as needed
                    height: 50, // Adjust as needed
                    child: CircularProgressIndicator(
                        value: downloadProgress.progress),
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              )),
              SizedBox(height: size.height * 0.02),
              //Container de Información
              Center(
                child: Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white60,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Información Mascota:",
                        style: getSubtitleBoldStyle(context),
                      ),
                      SizedBox(height: size.height * 0.01),
                      //Email
                      Text(
                        "Nombre: ${patient.nickname}",
                        style: getSubtitleStyle(context),
                      ),
                      SizedBox(height: size.height * 0.005),
                      //Telefono
                      Text(
                        "Edad: ${patient.age} años",
                        style: getSubtitleStyle(context),
                      ),
                      SizedBox(height: size.height * 0.005),
                      //Direccion
                      Text(
                        "Peso: ${patient.weight} kg",
                        style: getSubtitleStyle(context),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.03),
              //Resultados
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Resultados:",
                    style: getSubtitleBoldStyle(context),
                  ),
                  IconButton(
                    onPressed: () async {
                      final cameraGalleryService =
                          DIServices.cameraGalleryService;
                      final file = await cameraGalleryService.takePhoto();
                      if (file == null) return;
                      if (context.mounted) {
                        context.push("/patient-image-change-form", extra: file);
                      }
                    },
                    icon: Icon(
                      Icons.add_a_photo,
                      size: size.height * 0.03,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.01),
              //Lista de Analisis
              patient.photos.isEmpty
                  ? Center(
                      child: Text(
                        "No hay analisis registrados",
                        style: getSubtitleStyle(context)
                            .copyWith(color: Colors.white),
                      ),
                    )
                  : SizedBox(
                      height: size.height * 0.15,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: patient.photos.length,
                        itemBuilder: (context, index) {
                          final photo = patient.photos[index];
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.02),
                            child: FadeInRight(
                              child: GestureDetector(
                                onTap: () {
                                  context.push(
                                    "/patient-result",
                                    extra: PatientResultScreenArguments(
                                      photo: photo,
                                      indexPhoto: index,
                                      patientId: patient.id,
                                    ),
                                  );
                                },
                                child: _buildPhotoAnalisis(photo, context),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
              SizedBox(height: size.height * 0.02),
            ],
          ),
        ),
        SizedBox(height: size.height * 0.05),
        Center(
          child: CustomFilledButton(
            text: "Editar Información",
            onPressed: () {
              ref.read(patientUpdateFormProvider.notifier).setData(patient);
              ref
                  .read(patientUpdateImageFormProvider.notifier)
                  .setData(patient);
              context.push("/patient-update-form");
            },
          ),
        ),
      ],
    );
  }

  Column _buildPhotoAnalisis(Photo photo, BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: CachedNetworkImage(
          imageUrl: "${photo.photo}?v=${DateTime.now().millisecondsSinceEpoch}",
          fit: BoxFit.cover,
          progressIndicatorBuilder: (context, url, downloadProgress) => Center(
            child: SizedBox(
              width: 50, // Adjust as needed
              height: 50, // Adjust as needed
              child: CircularProgressIndicator(
                value: downloadProgress.progress,
                strokeWidth: 2,
              ),
            ),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        )),
        const SizedBox(height: 10),
        Text(
          photo.predictedClass ?? "no-class",
          style: getSubtitleBoldStyle(context).copyWith(
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
