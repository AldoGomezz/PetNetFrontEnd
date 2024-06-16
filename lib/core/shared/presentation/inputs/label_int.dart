import 'package:formz/formz.dart';

// Define input validation errors
enum LabelIntError { empty, notInteger }

// Extend FormzInput and provide the input type and error type.
class LabelInt extends FormzInput<String, LabelIntError> {
  // Call super.pure to represent an unmodified form input.
  const LabelInt.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const LabelInt.dirty(super.value) : super.dirty();

  String? get errorMessage {
    if (isValid || isPure) return null;

    switch (error) {
      case LabelIntError.empty:
        return 'El campo es requerido';
      case LabelIntError.notInteger:
        return 'El campo solo acepta valores enteros';
      default:
        return null;
    }
  }

  // Override validator to handle validating a given input value.
  @override
  LabelIntError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return LabelIntError.empty;
    if (!value
        .trim()
        .split('')
        .every((element) => '0123456789'.contains(element))) {
      return LabelIntError.notInteger;
    }

    return null;
  }
}
