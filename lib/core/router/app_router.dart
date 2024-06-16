import 'package:camera/camera.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_net_app/core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_net_app/features/auth/presentation/presentation.dart';
import 'package:pet_net_app/features/camera/presentation/presentation.dart';
import 'package:pet_net_app/features/history/presentation/presentation.dart';
import 'package:pet_net_app/features/home/presentation/presentation.dart';
import 'package:pet_net_app/features/owner/domain/domain.dart';
import 'package:pet_net_app/features/owner/presentation/presentation.dart';
import 'package:pet_net_app/features/patient/domain/domain.dart';
import 'package:pet_net_app/features/patient/presentation/presentation.dart';
import 'package:pet_net_app/features/predict/presentation/presentation.dart';
import 'package:pet_net_app/features/profile/presentation/presentation.dart';

final goRouterProvider =
    Provider.family<GoRouter, List<CameraDescription>>((ref, cameras) {
  final goRouterNotifier = ref.watch(goRouterNotifierProvider);
  return GoRouter(
    initialLocation: "/",
    refreshListenable: goRouterNotifier,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: "/",
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: "/login",
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: "/register",
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: "/home",
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: "/profile-info",
        builder: (context, state) => const ProfileInfo(),
      ),
      GoRoute(
        path: "/profile-info-form",
        builder: (context, state) => const ProfileInfoForm(),
      ),
      GoRoute(
        path: "/camera",
        builder: (context, state) {
          return CameraScreen(cameras: cameras);
        },
      ),
      GoRoute(
        path: "/predict",
        builder: (context, state) {
          final imagePath = state.extra as XFile;
          return PredictScreen(image: imagePath);
        },
      ),
      GoRoute(
        path: "/historias-clinicas",
        builder: (context, state) => const HistoriasClinicas(),
      ),
      GoRoute(
        path: "/patient-generate-form",
        builder: (context, state) => const PatientGenerateFormScreen(),
      ),
      GoRoute(
        path: "/owner-screen",
        builder: (context, state) => const OwnerScreen(),
      ),
      GoRoute(
        path: "/owner-info",
        builder: (context, state) {
          return const OwnerInfoScreen();
        },
      ),
      GoRoute(
        path: "/owner-form",
        builder: (context, state) => const OwnerFormScreen(),
      ),
      GoRoute(
        path: "/owner-update-form",
        builder: (context, state) {
          final owner = state.extra as OwnerModel;
          return OwnerUpdateFormScreen(owner: owner);
        },
      ),
      GoRoute(
        path: "/patient-info",
        builder: (context, state) {
          final patient = state.extra as PatientModel;
          return PatientInfoScreen(patient: patient);
        },
      ),
      GoRoute(
        path: "/patient-form",
        builder: (context, state) => const PatientFormScreen(),
      ),
      GoRoute(
        path: "/patient-update-form",
        builder: (context, state) {
          return const PatientUpdateFormScreen();
        },
      ),
      GoRoute(
        path: "/patient-image-change",
        builder: (context, state) {
          return const PatientImageChangeScreen();
        },
      ),
      GoRoute(
        path: "/patient-image-change-form",
        builder: (context, state) {
          final imagePath = state.extra as XFile;
          return PredictPatientScreen(image: imagePath);
        },
      ),
      GoRoute(
        path: "/patient-result",
        builder: (context, state) {
          final patientResult = state.extra as PatientResultScreenArguments;
          return PatientResultScreen(patientResult: patientResult);
        },
      ),
    ],
    redirect: (context, state) {
      final authStatus = goRouterNotifier.authStatus;
      final isGoingTo = state.matchedLocation;
      if (isGoingTo == "/" && authStatus == AuthStatus.checking) {
        return null;
      }

      if (authStatus == AuthStatus.notAuthenticated) {
        if (isGoingTo == "/login" || isGoingTo == "/register") return null;

        return "/login";
      }

      if (authStatus == AuthStatus.authenticated) {
        if (isGoingTo == "/login" || isGoingTo == "/") return "/home";
        return null;
      }
      return null;
    },
  );
});
