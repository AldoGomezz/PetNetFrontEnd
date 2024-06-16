import 'package:flutter/material.dart';

class CircularIconButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback? onPressed;

  const CircularIconButton({super.key, required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black.withOpacity(0.5),
      ),
      child: IconButton(
        icon: icon,
        color: Colors.white,
        onPressed: onPressed,
      ),
    );
  }
}
