import 'package:formz/formz.dart';

// Define input validation errors
enum NumberError { empty, format }

// Extend FormzInput and provide the input type and error type.
class Number extends FormzInput<String, NumberError> {
  static final RegExp numberRegExp = RegExp(
    r'^[0-9]{9,}$',
  );

  // Call super.pure to represent an unmodified form input.
  const Number.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const Number.dirty(super.value) : super.dirty();

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == NumberError.empty) return 'El campo es requerido';
    if (displayError == NumberError.format) {
      return 'Debe contener al menos 9 dígitos numéricos';
    }

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  NumberError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return NumberError.empty;
    if (!numberRegExp.hasMatch(value)) return NumberError.format;

    return null;
  }
}
