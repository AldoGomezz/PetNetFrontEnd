import 'package:flutter/material.dart';

class CustomDropDownButton extends StatelessWidget {
  final List<DropdownMenuItem<dynamic>>? items;
  final TextStyle? titleStyle;
  final String hintText;
  final Function(dynamic)? onChanged;
  final String? errorMessage;
  final dynamic initialValue;
  final InputBorder? borde;
  final BorderRadius? borderRadius;
  const CustomDropDownButton({
    super.key,
    required this.items,
    required this.hintText,
    this.onChanged,
    this.initialValue,
    this.borderRadius,
    this.titleStyle,
    this.errorMessage,
    this.borde,
  });

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.circular(15));

    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: borderRadius,
      ),
      child: DropdownButtonFormField(
        value: initialValue,
        style:
            titleStyle ?? textTheme.titleSmall?.copyWith(color: Colors.black54),
        borderRadius: borderRadius,
        decoration: InputDecoration(
          errorText: errorMessage,
          floatingLabelStyle: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          enabledBorder: borde ?? border,
          focusedBorder: borde ?? border,
          errorBorder: borde ??
              border.copyWith(
                borderSide: const BorderSide(color: Colors.transparent),
              ),
          focusedErrorBorder: borde ??
              border.copyWith(
                  borderSide: const BorderSide(color: Colors.transparent)),
          isDense: true,
        ),
        focusColor: Colors.transparent,
        isDense: true,
        isExpanded: true,
        hint: Text(hintText),
        items: items,
        onChanged: onChanged,
      ),
    );
  }
}
