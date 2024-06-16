import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pet_net_app/core/core.dart';

class RetryWidget extends StatelessWidget {
  final String errorMessage;
  final TextStyle? styleError;
  final Color? btnColor;
  final void Function()? onPressed;
  const RetryWidget({
    super.key,
    this.btnColor,
    this.styleError,
    this.onPressed,
    required this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(errorMessage, style: styleError ?? getSubtitleStyle(context)),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: btnColor ?? theme.colorScheme.primary,
              foregroundColor: Colors.black,
            ),
            onPressed: onPressed,
            child: Text(
              l10n.retry,
              style: getSubtitleStyle(context).copyWith(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
