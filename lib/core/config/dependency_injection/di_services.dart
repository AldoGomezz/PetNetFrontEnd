import 'package:get_it/get_it.dart';
import 'package:pet_net_app/core/shared/data/data.dart';

void injectServices() {
  GetIt.I.registerLazySingleton<KeyValueStorageService>(
    () => KeyValueStorageServiceImpl(),
  );
  GetIt.I.registerLazySingleton<CameraGalleryService>(
    () => CameraGalleryServiceImpl(),
  );
}

class DIServices {
  DIServices._();

  static KeyValueStorageService get keyValueStorageService =>
      GetIt.I.get<KeyValueStorageService>();

  static CameraGalleryService get cameraGalleryService =>
      GetIt.I.get<CameraGalleryService>();
}
