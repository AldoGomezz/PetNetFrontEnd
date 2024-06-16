import 'package:formz/formz.dart';

// Define input validation errors
enum LabelWithEmptyError { lenght }

// Extend FormzInput and provide the input type and error type.
class LabelWithEmpty extends FormzInput<String, LabelWithEmptyError> {
  // Call super.pure to represent an unmodified form input.
  const LabelWithEmpty.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const LabelWithEmpty.dirty(super.value) : super.dirty();

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (error == LabelWithEmptyError.lenght) return 'Mínimo 2 carácteres';

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  LabelWithEmptyError? validator(String value) {
    if (value.isEmpty) return null;
    if (value.length < 2) {
      return LabelWithEmptyError.lenght; // Validar según tus criterios
    }
    return null;
  }
}
