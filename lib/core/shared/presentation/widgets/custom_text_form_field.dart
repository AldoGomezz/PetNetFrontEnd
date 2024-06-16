import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pet_net_app/core/core.dart';

class CustomTextFormField extends StatelessWidget {
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
  const CustomTextFormField({
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
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    final border = OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(15),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: style ?? getSubtitleStyle(context)),
        SizedBox(height: size.height * 0.015),
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: readOnly ? theme.tbReadOnlyColor : theme.textboxColor,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
                //height: height ?? size.height * 0.06,
                child: TextFormField(
                  inputFormatters: inputFormatters,
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
                  style: readOnly
                      ? getSubtitleStyle(context)
                          .copyWith(color: theme.textReadOnlyColor)
                      : getSubtitleStyle(context),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 10.0,
                    ),
                    suffixIcon: suffixIcon,
                    floatingLabelStyle: getSubtitleStyle(context),
                    enabledBorder: border,
                    focusedBorder: border,
                    errorBorder: border.copyWith(
                        borderSide:
                            const BorderSide(color: Colors.transparent)),
                    focusedErrorBorder: border.copyWith(
                        borderSide:
                            const BorderSide(color: Colors.transparent)),
                    isDense: true,
                    label: Text(
                      labelField ?? "",
                      style: readOnly
                          ? getSubtitleStyle(context)
                              .copyWith(color: Colors.grey[600])
                          : getSubtitleStyle(context),
                    ),
                    hintText: hint,
                    errorText: errorMessage,
                    focusColor: theme.colorScheme.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            widget ?? const SizedBox.shrink(),
          ],
        ),
      ],
    );
  }
}
