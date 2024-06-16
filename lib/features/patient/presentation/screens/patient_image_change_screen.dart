import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_net_app/core/core.dart';
import 'package:pet_net_app/features/patient/presentation/presentation.dart';

class PatientImageChangeScreen extends ConsumerWidget {
  const PatientImageChangeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;
    final patientImageForm = ref.watch(patientUpdateImageFormProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.secondary,
        title: Text(
          "Cambiar Imagen",
          style: getTitleBoldStyle(context),
        ),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            patientImageForm.profilePhoto != null
                ? Image.memory(
                    patientImageForm.profilePhoto!,
                    width: size.width * 0.4,
                  )
                : patientImageForm.profilePhotoUrl.isNotEmpty
                    ? Image.network(
                        "${patientImageForm.profilePhotoUrl}?v=${DateTime.now().millisecondsSinceEpoch}",
                        width: size.width * 0.5,
                        height: size.height * 0.5,
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      )
                    : Icon(
                        Icons.pets,
                        size: size.height * 0.15,
                        color: colorScheme.secondary,
                      ),
            SizedBox(width: size.width * 0.02),
            patientImageForm.isPosting
                ? const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : IconButton(
                    onPressed: () async {
                      final cameraGalleryService =
                          DIServices.cameraGalleryService;
                      final file = await cameraGalleryService.selectPhoto();
                      if (file != null && context.mounted) {
                        //XFile a bytes
                        final bytes = File(file.path).readAsBytesSync();
                        await ref
                            .read(patientUpdateImageFormProvider.notifier)
                            .onProfilePhotoChanged(bytes);
                        await ref
                            .read(patientUpdateImageFormProvider.notifier)
                            .onProfilePhotoNameChanged(
                                file.path.split("/").last);

                        await ref
                            .read(patientUpdateImageFormProvider.notifier)
                            .onFormSubmit();
                      }
                    },
                    icon: Icon(
                      Icons.camera_alt,
                      size: size.height * 0.03,
                      color: Colors.black,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
