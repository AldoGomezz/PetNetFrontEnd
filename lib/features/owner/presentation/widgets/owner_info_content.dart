import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_net_app/core/core.dart';
import 'package:pet_net_app/features/owner/presentation/presentation.dart';
import 'package:pet_net_app/features/patient/presentation/presentation.dart';

class OwnerInfoContent extends ConsumerWidget {
  const OwnerInfoContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final owner = ref.watch(ownerGetProvider).owner;
    final size = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;
    String fullName = "${owner?.firstName} ${owner?.lastName}";
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Titulo
            Center(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  "Dueño Información",
                  style: getTitleBoldStyle(context),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: size.height * 0.05),
            //Container Owner
            Container(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
              decoration: BoxDecoration(
                color: colorScheme.tertiary,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.height * 0.02),
                  //Imagen
                  Center(
                    child: Image.asset(
                      "assets/profile.png",
                      height: size.height * 0.15,
                    ),
                  ),
                  SizedBox(height: size.height * 0.005),
                  //Nombre
                  Center(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * 0.05),
                      child: Text(
                        fullName,
                        style: getTitleBoldStyle(context).copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  //Container de Información
                  Center(
                    child: Container(
                      width: double.maxFinite,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white60,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Información Dueño:",
                            style: getSubtitleBoldStyle(context),
                          ),
                          SizedBox(height: size.height * 0.01),
                          //Email
                          Text(
                            "DNI: ${owner?.document}",
                            style: getSubtitleStyle(context),
                          ),
                          SizedBox(height: size.height * 0.005),
                          //Telefono
                          Text(
                            "Email: ${owner?.email}",
                            style: getSubtitleStyle(context),
                          ),
                          SizedBox(height: size.height * 0.005),
                          //Direccion
                          Text(
                            "Telefono: ${owner?.phoneNumber}",
                            style: getSubtitleStyle(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  //Mascotas
                  Text(
                    "Mascotas:",
                    style: getSubtitleBoldStyle(context),
                  ),
                  SizedBox(height: size.height * 0.01),
                  //Lista de Mascotas
                  owner?.patients == null
                      ? Center(
                          child: Text(
                            "No hay mascotas registradas",
                            style: getSubtitleStyle(context),
                          ),
                        )
                      : SizedBox(
                          height: size.height * 0.15,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: owner!.patients!.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.02),
                                child: FadeInRight(
                                  child: PatientCard(
                                    patient: owner.patients![index],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                  SizedBox(height: size.height * 0.02),
                ],
              ),
            ),
            SizedBox(height: size.height * 0.05),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomFilledButton(
                  text: "Nuevo (Mascota)",
                  style: getSubtitleBoldStyle(context),
                  onPressed: () {
                    ref.read(patientRegisterFormProvider.notifier).logout();
                    ref
                        .read(patientRegisterFormProvider.notifier)
                        .setOwnerId(owner?.id! ?? 0);
                    context.push("/patient-form");
                  },
                ),
                CustomFilledButton(
                  text: "Editar (Dueño)",
                  style: getSubtitleBoldStyle(context),
                  onPressed: () {
                    context.push("/owner-update-form", extra: owner);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
