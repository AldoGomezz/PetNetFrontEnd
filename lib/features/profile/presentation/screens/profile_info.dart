import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_net_app/core/core.dart';
import 'package:pet_net_app/features/user/presentation/providers/uset_get_provider.dart';

class ProfileInfo extends ConsumerWidget {
  const ProfileInfo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final userGetInfo = ref.watch(userGetProvider);
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
            top: size.height * 0.05,
            left: size.width * 0.02,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                context.pop();
              },
            ),
          ),
          //Content
          Positioned(
            top: size.height * 0.1,
            child: _buildContent(context, size, userGetInfo),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    Size size,
    UserGetState userGetState,
  ) {
    return SizedBox(
      height: size.height * 0.8,
      width: size.width,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: size.height * 0.05),
            RichText(
              text: TextSpan(
                text: "Nombre: ",
                style: getTitleBoldStyle(context),
                children: [
                  TextSpan(
                    text: userGetState.user?.firstName ?? "no-name",
                    style: getTitleStyle(context),
                  ),
                ],
              ),
            ),
            SizedBox(height: size.height * 0.02),
            RichText(
              text: TextSpan(
                text: "Apellido: ",
                style: getTitleBoldStyle(context),
                children: [
                  TextSpan(
                    text: userGetState.user?.lastName ?? "no-lastname",
                    style: getTitleStyle(context),
                  ),
                ],
              ),
            ),
            SizedBox(height: size.height * 0.02),
            RichText(
              text: TextSpan(
                text: "Email: ",
                style: getTitleBoldStyle(context),
                children: [
                  TextSpan(
                    text: userGetState.user?.email ?? "no-email",
                    style: getTitleStyle(context),
                  ),
                ],
              ),
            ),
            SizedBox(height: size.height * 0.02),
            RichText(
              text: TextSpan(
                text: "Usuario: ",
                style: getTitleBoldStyle(context),
                children: [
                  TextSpan(
                    text: userGetState.user?.username ?? "no-username",
                    style: getTitleStyle(context),
                  ),
                ],
              ),
            ),
            SizedBox(height: size.height * 0.02),
            RichText(
              text: TextSpan(
                text: "Clínica: ",
                style: getTitleBoldStyle(context),
                children: [
                  TextSpan(
                    text: userGetState.user?.clinic ?? "no-clinic",
                    style: getTitleStyle(context),
                  ),
                ],
              ),
            ),
            SizedBox(height: size.height * 0.02),
            RichText(
              text: TextSpan(
                text: "Dirección de clínica: ",
                style: getTitleBoldStyle(context),
                children: [
                  TextSpan(
                    text: userGetState.user?.address ?? "no-address",
                    style: getTitleStyle(context),
                  ),
                ],
              ),
            ),
            SizedBox(height: size.height * 0.02),
            RichText(
              text: TextSpan(
                text: "Número de colegiatura: ",
                style: getTitleBoldStyle(context),
                children: [
                  TextSpan(
                    text:
                        userGetState.user?.collegeNumber ?? "no-college-number",
                    style: getTitleStyle(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
