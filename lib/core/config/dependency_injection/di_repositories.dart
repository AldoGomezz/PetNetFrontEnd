import 'package:get_it/get_it.dart';
import 'package:pet_net_app/features/auth/data/data.dart';
import 'package:pet_net_app/features/auth/domain/domain.dart';
import 'package:pet_net_app/features/owner/data/data.dart';
import 'package:pet_net_app/features/owner/domain/domain.dart';
import 'package:pet_net_app/features/predict/data/data.dart';
import 'package:pet_net_app/features/predict/domain/domain.dart';
import 'package:pet_net_app/features/profile/data/data.dart';
import 'package:pet_net_app/features/profile/domain/domain.dart';
import 'package:pet_net_app/features/user/data/data.dart';
import 'package:pet_net_app/features/user/domain/domain.dart';

void injectRepositories() {
  GetIt.I.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(),
  );
  GetIt.I.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(),
  );
  GetIt.I.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(),
  );
  GetIt.I.registerLazySingleton<PredictRepository>(
    () => PredictRepositoryImpl(),
  );
  GetIt.I.registerLazySingleton<OwnerRepository>(() => OwnerRepositoryImpl());
}

class DIRepositories {
  DIRepositories._();

  static AuthRepository get authRepository => GetIt.I.get<AuthRepository>();
  static UserRepository get userRepository => GetIt.I.get<UserRepository>();
  static ProfileRepository get profileRepository =>
      GetIt.I.get<ProfileRepository>();
  static PredictRepository get predictRepository =>
      GetIt.I.get<PredictRepository>();
  static OwnerRepository get ownerRepository => GetIt.I.get<OwnerRepository>();
}
