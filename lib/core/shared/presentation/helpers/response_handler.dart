import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_net_app/core/shared/presentation/presentation.dart';

class ResponseHandler {
  static void handle401Response(
    BuildContext context,
    WidgetRef ref,
    VoidCallback resetResponse,
  ) {
    final l10n = AppLocalizations.of(context)!;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      CustomDialogs().showAlert(
        barrierDismissible: false,
        context: context,
        title: l10n.session_expired,
        subtitle: l10n.sign_in_again,
        actions: [
          TextButton(
            onPressed: () => logout(ref),
            child: Text(l10n.accept),
          ),
        ],
      );
      resetResponse();
    });
  }
}
