import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_net_app/core/core.dart';

class DrawerWidget extends ConsumerStatefulWidget {
  const DrawerWidget({super.key});

  @override
  DrawerWidgetState createState() => DrawerWidgetState();
}

class DrawerWidgetState extends ConsumerState<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    final hasNotch = MediaQuery.of(context).viewPadding.top > 30;
    final colorScheme = Theme.of(context).colorScheme;

    final drawerSelection = ref.watch(drawerSelectionProvider);

    return Drawer(
      child: Material(
        color: colorScheme.secondary,
        child: Padding(
          padding: EdgeInsets.only(top: hasNotch ? 10 : 20),
          child: ListView(
            children: [
              ListTile(
                leading: Image.asset(
                  'assets/logo/pet_net.png',
                  height: 40,
                ),
                title: Text("PetNet", style: getTitleBoldStyle(context)),
              ),
              const SizedBox(height: 20),
              _MenuItem(
                text: "Perfil",
                colorScheme: colorScheme,
                textStyle: getSubtitleStyle600(context),
                isSelected: drawerSelection == DrawerSelection.profile,
                onTap: () {
                  ref.read(drawerSelectionProvider.notifier).state =
                      DrawerSelection.profile;
                },
              ),
              _MenuItem(
                text: "Ayuda",
                colorScheme: colorScheme,
                textStyle: getSubtitleStyle600(context),
                isSelected: drawerSelection == DrawerSelection.help,
                onTap: () {
                  ref.read(drawerSelectionProvider.notifier).state =
                      DrawerSelection.help;
                },
              ),
              _MenuItem(
                text: "Cerrar sesión",
                colorScheme: colorScheme,
                textStyle: getSubtitleStyle600(context),
                isSelected: drawerSelection == DrawerSelection.signOut,
                onTap: () {
                  logout(ref);
                  ref.read(drawerSelectionProvider.notifier).state =
                      DrawerSelection.profile;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final String text;
  //final IconData dataIcon;
  final ColorScheme colorScheme;
  final TextStyle textStyle;
  final Function()? onTap;
  final bool isSelected;
  const _MenuItem({
    required this.text,
    //required this.dataIcon,
    required this.colorScheme,
    required this.textStyle,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Text(
          text,
          style: textStyle,
        ),
        onTap: onTap,
      ),
    );
  }
}
