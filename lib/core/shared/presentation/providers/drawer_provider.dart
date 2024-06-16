import 'package:flutter_riverpod/flutter_riverpod.dart';

enum DrawerSelection { profile, help, signOut }

final drawerSelectionProvider = StateProvider<DrawerSelection>((ref) {
  return DrawerSelection.profile;
});
