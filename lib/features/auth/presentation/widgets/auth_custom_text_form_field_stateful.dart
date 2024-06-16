import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pet_net_app/core/core.dart';

class AuthCustomTextFormFieldStateful extends StatefulWidget {
  final String label;
  final Widget? widget;
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
  final List<TextInputFormatter>? inputFormatters;
  const AuthCustomTextFormFieldStateful({
    super.key,
    this.height,
    this.labelField,
    this.widget,
    this.readOnly = false,
    this.initialValue,
    this.controller,
    required this.label,
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
    this.inputFormatters,
  });

  @override
  State<AuthCustomTextFormFieldStateful> createState() =>
      _AuthCustomTextFormFieldStatefulState();
}

class _AuthCustomTextFormFieldStatefulState
    extends State<AuthCustomTextFormFieldStateful> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    final border = OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(5),
    );
    return Container(
      decoration: BoxDecoration(
        color: widget.readOnly ? theme.tbReadOnlyColor : theme.textboxColor,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
      ),
      //height: height ?? size.height * 0.06,
      child: TextFormField(
        inputFormatters: widget.inputFormatters,
        controller: widget.controller,
        readOnly: widget.readOnly,
        initialValue: widget.initialValue,
        maxLines: widget.maxLines ?? 1,
        textDirection: TextDirection.ltr,
        expands: false,
        onChanged: widget.onChanged,
        validator: widget.validator,
        obscureText: _obscureText,
        onFieldSubmitted: widget.onFieldSubmitted,
        keyboardType: widget.keyboardType,
        style: widget.readOnly
            ? getSubtitleStyle(context).copyWith(color: theme.textReadOnlyColor)
            : getSubtitleStyle(context),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 10.0,
          ),
          suffixIcon: widget.obscureText
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey.shade600,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : null,
          floatingLabelStyle: getSubtitleStyle(context),
          enabledBorder: border,
          focusedBorder: border,
          errorBorder: border.copyWith(
              borderSide: const BorderSide(color: Colors.transparent)),
          focusedErrorBorder: border.copyWith(
              borderSide: const BorderSide(color: Colors.transparent)),
          isDense: true,
          label: Text(
            widget.label,
            style: widget.readOnly
                ? getSubtitleStyle(context).copyWith(color: Colors.grey[600])
                : getSubtitleStyle(context),
          ),
          hintText: widget.hint,
          errorText: widget.errorMessage,
          focusColor: theme.colorScheme.primary,
        ),
      ),
    );
  }
}
