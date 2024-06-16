import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomBarTextFormField extends StatelessWidget {
  final bool readOnly;
  final String? initialValue;
  final String? hint;
  final String? errorMessage;
  final FocusNode? focusNode;
  final int? maxLines;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;
  final TextStyle? style;
  final Widget? suffixIcon;
  final InputBorder? border;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  const CustomBarTextFormField({
    super.key,
    this.readOnly = false,
    this.focusNode,
    this.initialValue,
    this.maxLines,
    this.hint,
    this.errorMessage,
    this.style,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.onFieldSubmitted,
    this.validator,
    this.suffixIcon,
    this.border,
    this.inputFormatters,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SizedBox(
      child: TextFormField(
        focusNode: focusNode,
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
        inputFormatters: inputFormatters,
        style: style ?? const TextStyle(fontSize: 16, color: Colors.black54),
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          floatingLabelStyle: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
          enabledBorder: border,
          focusedBorder: border,
          errorBorder: border,
          focusedErrorBorder: border,
          isDense: true,
          //label: label != null ? Text(label!) : null,
          hintText: hint,
          errorText: errorMessage,
          focusColor: colors.primary,
        ),
      ),
    );
  }
}
