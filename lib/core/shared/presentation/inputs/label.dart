import 'package:formz/formz.dart';

// Define input validation errors
enum LabelError { empty, lenght }

// Extend FormzInput and provide the input type and error type.
class Label extends FormzInput<String, LabelError> {
  // Call super.pure to represent an unmodified form input.
  const Label.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const Label.dirty(super.value) : super.dirty();

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (error == LabelError.empty) return 'El campo es requerido';
    if (error == LabelError.lenght) return 'Mínimo 2 carácteres';

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  LabelError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return LabelError.empty;
    if (value.length < 2) {
      return LabelError.lenght;
    }
    return null;
  }
}
