import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_net_app/features/auth/presentation/presentation.dart';

void logout(WidgetRef ref) {
  ref.read(authProvider.notifier).logout();
  ref.read(loginFormProvider.notifier).logout();
}
