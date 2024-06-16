import 'package:flutter/material.dart';
import 'package:pet_net_app/core/shared/presentation/presentation.dart';
import 'package:pet_net_app/features/history/presentation/widgets/widgets.dart';

class HistoriasClinicas extends StatelessWidget {
  const HistoriasClinicas({super.key});

  @override
  Widget build(BuildContext context) {
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
          //Boton de regreso
          Positioned(
            top: 0,
            left: 0,
            child: SafeArea(
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
          //Content
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: HistoriasClinicasContent(),
          ),
        ],
      ),
    );
  }
}
