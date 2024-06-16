import 'package:flutter/material.dart';
import 'package:pet_net_app/core/core.dart';
import 'package:pet_net_app/features/auth/presentation/presentation.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          child: SizedBox(
            height: size.height,
            child: Stack(
              children: [
                // Background
                const Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: BackgroundWidget(),
                ),
                //Botón de regreso
                Positioned(
                  top: size.height * 0.05,
                  left: size.width * 0.015,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                //Icono de ayuda
                /* Positioned(
                  top: size.height * 0.05,
                  right: size.width * 0.015,
                  child: GestureDetector(
                    onTap: () {},
                    child: Image.asset(
                      'assets/icons/help.png',
                      height: size.height * 0.045,
                    ),
                  ),
                ), */
                // Formulario
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: size.height * 0.12,
                      left: size.width * 0.1,
                      right: size.width * 0.1,
                    ),
                    child: const RegisterFormCard(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
