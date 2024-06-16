import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pet_net_app/core/core.dart';
import 'package:pet_net_app/features/history/presentation/presentation.dart';
import 'package:pet_net_app/features/profile/presentation/presentation.dart';
import 'package:pet_net_app/features/user/presentation/presentation.dart';

class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final userGetPv = ref.watch(userGetProvider);

    String firstName = userGetPv.user?.firstName ?? "no-name";
    String lastName = userGetPv.user?.lastName ?? "no-last-name";

    String email = userGetPv.user?.email ?? "no-email";

    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: size.height,
      width: size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: size.height * 0.2),
          _ProfileCard(
            size: size,
            firstName: firstName,
            lastName: lastName,
            email: email,
          ),
          SizedBox(height: size.height * 0.05),
          _ProfileOption(
            title: "Opciones de Perfil",
            subTitle: "Modifica tu información.",
            icon: Icons.person_outline,
            topColor: colorScheme.primary,
            bottomColor: ColorsCustom.redBtnOp,
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    title: Text(
                      "Opciones de Perfil",
                      style: getTitleBoldStyle(context),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: Text(
                            "Mi perfil",
                            style: getSubtitleStyle(context),
                          ),
                          onTap: () {
                            context.push("/profile-info");
                          },
                        ),
                        ListTile(
                          title: Text(
                            "Editar perfil",
                            style: getSubtitleStyle(context),
                          ),
                          onTap: () async {
                            await ref
                                .read(profileFormProvider.notifier)
                                .logout();
                            if (context.mounted) {
                              ref
                                  .read(profileFormProvider.notifier)
                                  .setData(userGetPv);
                              context.push("/profile-info-form");
                            }
                          },
                        ),
                        /* ListTile(
                          title: Text(
                            "Editar Correo",
                            style: getSubtitleStyle(context),
                          ),
                          onTap: () {},
                        ), */
                        ListTile(
                          title: Text(
                            "Cambiar contraseña",
                            style: getSubtitleStyle(context),
                          ),
                          onTap: () {},
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(height: 20),
          _ProfileOption(
            title: "Nuevo Análisis",
            subTitle: "Analiza una imagen.",
            icon: Icons.search,
            topColor: ColorsCustom.redBtn2,
            bottomColor: ColorsCustom.redBtn2Op,
            onTap: () async {
              PermissionStatus status = await Permission.camera.request();
              if (status.isGranted && context.mounted) {
                context.push("/camera");
              } else {
                if (context.mounted) {
                  CustomDialogs().showAlert(
                    context: context,
                    title: "Permisos",
                    subtitle: "Necesitas dar permisos para acceder a la cámara",
                  );
                }
              }
            },
          ),
          const SizedBox(height: 20),
          _ProfileOption(
            title: "Historias Clínicas",
            subTitle: "Revisa las historias de tus pracientes.",
            icon: Icons.history_sharp,
            topColor: ColorsCustom.redBtn3,
            bottomColor: ColorsCustom.redBtn3Op,
            onTap: () {
              ref
                  .read(historySearchBarProvider.notifier)
                  .onSearchTypeChange(SearchType.patient);
              context.push("/historias-clinicas");
            },
          ),
        ],
      ),
    );
  }
}

class _ProfileOption extends StatelessWidget {
  final String title;
  final String subTitle;
  final IconData icon;
  final Function() onTap;
  final Color topColor;
  final Color bottomColor;
  const _ProfileOption({
    required this.title,
    required this.subTitle,
    required this.icon,
    required this.onTap,
    this.topColor = Colors.blue,
    this.bottomColor = Colors.blueAccent,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height * 0.055;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: height * 2,
        width: size.width,
        child: Stack(
          children: [
            // Upper half
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: height * 2,
                decoration: BoxDecoration(
                  color: bottomColor,
                ),
              ),
            ),
            // Lower half
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: ClipPath(
                clipper: WaveClipper(),
                child: Container(
                  height: height * 2,
                  color: topColor,
                ),
              ),
            ),
            //Contenido
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Center(
                    child: Icon(
                      icon,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: getSubtitleStyle600(context).copyWith(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        subTitle,
                        style: getSubSmallSubtitleStyle(context).copyWith(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
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

String capitalize(String s) =>
    s[0].toUpperCase() + s.substring(1).toLowerCase();

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({
    required this.size,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  final Size size;
  final String firstName;
  final String lastName;
  final String email;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "¡Hola, ${capitalize(firstName)}!",
            style: getHeaderStyle(context).copyWith(fontSize: 25),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          Text(
            "Correo: $email",
            style: getSubtitleStyle(context).copyWith(
              color: Colors.grey.shade600,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    var startPoint = Offset(0, size.height / 2);
    var controlPoint1 = Offset(size.width / 4, size.height / 4);
    var controlPoint2 = Offset(size.width / 4 * 3, size.height / 4 * 3);
    var endPoint = Offset(size.width, size.height / 2);

    path.moveTo(startPoint.dx, startPoint.dy);
    path.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx,
        controlPoint2.dy, endPoint.dx, endPoint.dy);

    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
