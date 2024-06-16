import 'package:flutter/material.dart';
import 'package:pet_net_app/core/core.dart';
import 'package:pet_net_app/features/patient/domain/domain.dart';
import 'package:pet_net_app/features/patient/presentation/presentation.dart';

class PatientInfoScreen extends StatelessWidget {
  final PatientModel patient;
  const PatientInfoScreen({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(
                top: size.height * 0.1,
                left: size.width * 0.05,
                right: size.width * 0.05,
              ),
              child: PatientInfoContent(patientId: patient.id),
            ),
          ),
        ],
      ),
    );
  }
}
