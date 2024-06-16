import 'package:formz/formz.dart';

// Define input validation errors
enum LabelDoubleError { empty, format }

// Extend FormzInput and provide the input type and error type.
class LabelDouble extends FormzInput<String, LabelDoubleError> {
  static final RegExp numberRegExp = RegExp(
    r'^\d*\.?\d*$',
  );
  // Call super.pure to represent an unmodified form input.
  const LabelDouble.pure() : super.pure('0.00');

  // Call super.dirty to represent a modified form input.
  const LabelDouble.dirty(super.value) : super.dirty();

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (error == LabelDoubleError.empty) return 'El campo es requerido';
    if (error == LabelDoubleError.format) return 'Solo carácteres numéricos';

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  LabelDoubleError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty || value == "0.00") {
      return LabelDoubleError.empty;
    }
    if (!numberRegExp.hasMatch(value)) return LabelDoubleError.format;
    return null;
  }
}
