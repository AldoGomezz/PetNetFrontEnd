import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_net_app/features/auth/presentation/presentation.dart';

final goRouterNotifierProvider = Provider(
  (ref) {
    final authNotifier = ref.watch(authProvider.notifier);
    return GoRouterNotifier(authNotifier: authNotifier);
  },
);

class GoRouterNotifier extends ChangeNotifier {
  final AuthNotifier authNotifier;
  AuthStatus _authStatus = AuthStatus.checking;

  GoRouterNotifier({
    required this.authNotifier,
  }) {
    authNotifier.addListener((state) async {
      authStatus = state.authStatus;
    });
  }

  AuthStatus get authStatus => _authStatus;

  set authStatus(AuthStatus value) {
    _authStatus = value;
    notifyListeners();
  }
}
