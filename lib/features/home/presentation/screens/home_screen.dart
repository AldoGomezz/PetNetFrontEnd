import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_net_app/core/core.dart';
import 'package:pet_net_app/features/profile/presentation/presentation.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final globalKey = GlobalKey<ScaffoldState>();

    final size = MediaQuery.of(context).size;

    final drawerSelection = ref.watch(drawerSelectionProvider);

    return Scaffold(
      key: globalKey,
      drawer: const DrawerWidget(),
      body: Stack(
        children: [
          //Background
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: BackgroundWidget(),
          ),
          //Content
          Positioned(
            top: 0,
            child: _buildContent(drawerSelection),
          ),
          //Drawer
          Positioned(
            top: 0,
            left: 0,
            child: _buildMenuButton(globalKey, size),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(DrawerSelection selection) {
    switch (selection) {
      case DrawerSelection.profile:
        return const ProfileView();
      case DrawerSelection.help:
        return const Center(
          child: Text("Help"),
        );
      case DrawerSelection.signOut:
        return Container();
      default:
        return Container();
    }
  }

  SafeArea _buildMenuButton(GlobalKey<ScaffoldState> globalKey, Size size) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () => globalKey.currentState?.openDrawer(),
          child: Image.asset(
            'assets/logo/pet_net.png',
            height: size.height * 0.05,
          ),
        ),
      ),
    );
  }
}
