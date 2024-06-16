import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:pet_net_app/core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PetNetApp extends ConsumerWidget {
  final List<CameraDescription> cameras;

  const PetNetApp({super.key, required this.cameras});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appRouter = ref.watch(goRouterProvider(cameras));
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: "PetNet",
      theme: AppTheme().getLightTheme(),
      locale: const Locale('es', "ES"),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routeInformationParser: appRouter.routeInformationParser,
      routeInformationProvider: appRouter.routeInformationProvider,
      routerDelegate: appRouter.routerDelegate,
    );
  }
}
