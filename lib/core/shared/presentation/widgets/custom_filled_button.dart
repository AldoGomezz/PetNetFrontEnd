import 'package:flutter/material.dart';
import 'package:pet_net_app/core/core.dart';

class CustomFilledButton extends StatelessWidget {
  final void Function()? onPressed;
  final String text;
  final TextStyle? style;
  final IconData? iconData;
  final double? width;
  final double? height;
  final Color? buttonColor;
  final double? borderRadius;

  const CustomFilledButton({
    super.key,
    this.onPressed,
    required this.text,
    this.style,
    this.iconData,
    this.buttonColor,
    this.height,
    this.width,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final radius = Radius.circular(borderRadius ?? 10.0);

    return FilledButton(
      style: FilledButton.styleFrom(
        minimumSize:
            width != null && height != null ? Size(width!, height!) : null,
        backgroundColor: buttonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(radius),
        ),
      ),
      onPressed: onPressed,
      child: iconData != null
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(iconData),
                Text(
                  text,
                  style: style ??
                      getSubtitleStyle(context).copyWith(
                        color: Colors.white,
                      ),
                ),
              ],
            )
          : Text(
              text,
              style: style ??
                  getSubtitleStyle(context).copyWith(
                    color: Colors.white,
                  ),
            ),
    );
  }
}
