import 'package:flutter/material.dart';

class CustomCameraTextFormField extends StatelessWidget {
  final String? labelField;
  final bool readOnly;
  final double? height;
  final int? maxLines;
  final TextEditingController? controller;
  final TextStyle? style;
  final String? initialValue;
  final String? hint;
  final String? errorMessage;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  const CustomCameraTextFormField({
    super.key,
    this.height,
    this.labelField,
    this.readOnly = false,
    this.initialValue,
    this.controller,
    this.style,
    this.hint,
    this.maxLines,
    this.errorMessage,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.onFieldSubmitted,
    this.validator,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final border = OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(15),
    );

    return Container(
      decoration: BoxDecoration(
        color: readOnly ? Colors.grey[200] : Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
      ),
      //height: height ?? size.height * 0.06,
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        initialValue: initialValue,
        maxLines: maxLines ?? 1,
        textDirection: TextDirection.ltr,
        expands: false,
        onChanged: onChanged,
        validator: validator,
        obscureText: obscureText,
        onFieldSubmitted: onFieldSubmitted,
        keyboardType: keyboardType,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 10.0,
          ),
          suffixIcon: suffixIcon,
          floatingLabelStyle: const TextStyle(
            fontSize: 14,
            color: Colors.transparent,
          ),
          enabledBorder: border,
          focusedBorder: border,
          errorBorder: border.copyWith(
              borderSide: const BorderSide(color: Colors.transparent)),
          focusedErrorBorder: border.copyWith(
              borderSide: const BorderSide(color: Colors.transparent)),
          isDense: true,
          label: Text(
            labelField ?? "",
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          hintText: hint,
          errorText: errorMessage,
          focusColor: colors.primary,
        ),
      ),
    );
  }
}
