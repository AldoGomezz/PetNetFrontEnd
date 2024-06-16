import 'package:flutter/material.dart';
import 'package:pet_net_app/core/core.dart';

class CustomDialogs {
  showAlert({
    required BuildContext context,
    required String title,
    required String subtitle,
    List<Widget>? actions,
    Color? color,
    bool? barrierDismissible,
  }) {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible ?? true,
      builder: (context) => PopScope(
        canPop: true,
        onPopInvoked: (didPop) async => barrierDismissible ?? false,
        // onWillPop: () async =>
        //     barrierDismissible != null ? !barrierDismissible : false,
        child: AlertDialog(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: Text(title, style: getTitleBoldStyle(context)),
          content: Text(subtitle, style: getSubtitleStyle(context)),
          actions: actions ??
              [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Ok",
                    style: getSubtitleStyle(context),
                  ),
                )
              ],
        ),
      ),
    );
  }

  void showSnackbar(BuildContext context, String errorMessage) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    if (scaffoldMessenger.mounted) {
      scaffoldMessenger.hideCurrentSnackBar();
      Future.delayed(const Duration(milliseconds: 500), () {
        if (scaffoldMessenger.mounted) {
          scaffoldMessenger.showSnackBar(SnackBar(content: Text(errorMessage)));
        }
      });
    }
  }
}
