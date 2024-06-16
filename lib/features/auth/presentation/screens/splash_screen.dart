import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_net_app/core/core.dart';
import 'package:pet_net_app/features/auth/presentation/presentation.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authProvider.notifier).checkAuthStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    //final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        //Gradiente con el color secundario y blanco
        decoration: const BoxDecoration(
          color: Colors.white,
          /* gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.secondary,
              Colors.white,
            ],
          ), */
        ),
        child: Stack(
          children: [
            // "Piso" circular
            Positioned(
              bottom: -size.height * 0.2,
              child: Container(
                width: size.width,
                height: size.height * 0.3,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(100),
                    topRight: Radius.circular(100),
                  ),
                ),
              ),
            ),
            // Logo
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: size.height * 0.04),
                child: Image.asset(
                  'assets/logo/new_pet_net.png',
                  height: size.height * 0.2,
                ),
              ),
            ),
            // Texto
            Center(
              child: Text(
                'PetNet',
                style: getHeaderStyle(context).copyWith(
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
