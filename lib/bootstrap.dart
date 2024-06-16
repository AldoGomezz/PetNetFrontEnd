import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_net_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/core.dart';

late List<CameraDescription> _cameras;

Future<void> bootstrap(
  EnvType envType,
  FutureOr<Widget> Function(List<CameraDescription> cameras) builder,
) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  _cameras = await availableCameras();
  await Environment.initEnvironment(envType);
  HttpOverrides.global = MyHttpOverrides();
  injectRepositories();
  injectServices();
  runApp(ProviderScope(child: await builder(_cameras)));
}
