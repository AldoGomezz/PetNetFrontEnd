import 'package:formz/formz.dart';
import 'package:pet_net_app/core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_net_app/features/owner/domain/domain.dart';
import 'package:pet_net_app/features/owner/presentation/presentation.dart';

//StateNotifierProvider
final ownerFormProvider =
    StateNotifierProvider<OwnerFormNotifier, OwnerFormState>((ref) {
  return OwnerFormNotifier(ref: ref);
});

//Notifier

class OwnerFormNotifier extends StateNotifier<OwnerFormState> {
  Ref ref;
  OwnerFormNotifier({
    required this.ref,
  }) : super(OwnerFormState());

  void logout() {
    state = OwnerFormState();
  }

  onNombreDuenoChanged(String value) {
    final nombresDueno = Label.dirty(value);
    state = state.copyWith(
      nombresDueno: nombresDueno,
      isValid: Formz.validate([
        nombresDueno,
        state.apellidosDueno,
        state.dniDueno,
        state.emailDueno,
        state.telefonoDueno,
      ]),
    );
  }

  onApellidosDuenoChanged(String value) {
    final apellidosDueno = Label.dirty(value);
    state = state.copyWith(
      apellidosDueno: apellidosDueno,
      isValid: Formz.validate([
        state.nombresDueno,
        apellidosDueno,
        state.dniDueno,
        state.emailDueno,
        state.telefonoDueno,
      ]),
    );
  }

  onDniDuenoChanged(String value) {
    final dniDueno = LabelInt.dirty(value);
    state = state.copyWith(
      dniDueno: dniDueno,
      isValid: Formz.validate([
        state.nombresDueno,
        state.apellidosDueno,
        dniDueno,
        state.emailDueno,
        state.telefonoDueno,
      ]),
    );
  }

  onEmailDuenoChanged(String value) {
    final emailDueno = Email.dirty(value);
    state = state.copyWith(
      emailDueno: emailDueno,
      isValid: Formz.validate([
        state.nombresDueno,
        state.apellidosDueno,
        state.dniDueno,
        emailDueno,
        state.telefonoDueno,
      ]),
    );
  }

  onTelefonoDuenoChanged(String value) {
    final telefonoDueno = Number.dirty(value);
    state = state.copyWith(
      telefonoDueno: telefonoDueno,
      isValid: Formz.validate([
        state.nombresDueno,
        state.apellidosDueno,
        state.dniDueno,
        state.emailDueno,
        telefonoDueno,
      ]),
    );
  }

  onFormSubmit() async {
    _touchEveryField();
    if (!state.isValid) return;
    state = state.copyWith(isPosting: true);
    await ref.read(ownerRegisterProvider.notifier).register(
          OwnerFormRequest(
            email: state.emailDueno.value,
            firstName: state.nombresDueno.value,
            lastName: state.apellidosDueno.value,
            document: state.dniDueno.value,
            phoneNumber: state.telefonoDueno.value,
          ),
        );
    await ref.read(ownerSearchProvider.notifier).search();
    state = state.copyWith(isPosting: false);
  }

  _touchEveryField() {
    final nombresDueno = Label.dirty(state.nombresDueno.value);
    final apellidosDueno = Label.dirty(state.apellidosDueno.value);
    final dniDueno = LabelInt.dirty(state.dniDueno.value);
    final emailDueno = Email.dirty(state.emailDueno.value);
    final telefonoDueno = Number.dirty(state.telefonoDueno.value);

    state = state.copyWith(
      isFormPosted: true,
      nombresDueno: nombresDueno,
      apellidosDueno: apellidosDueno,
      dniDueno: dniDueno,
      emailDueno: emailDueno,
      telefonoDueno: telefonoDueno,
      isValid: Formz.validate([
        nombresDueno,
        apellidosDueno,
        dniDueno,
        emailDueno,
        telefonoDueno,
      ]),
    );
  }
}

//State

class OwnerFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Label nombresDueno;
  final Label apellidosDueno;
  final LabelInt dniDueno;
  final Email emailDueno;
  final Number telefonoDueno;

  OwnerFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.nombresDueno = const Label.pure(),
    this.apellidosDueno = const Label.pure(),
    this.dniDueno = const LabelInt.pure(),
    this.emailDueno = const Email.pure(),
    this.telefonoDueno = const Number.pure(),
  });

  OwnerFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Label? nombresDueno,
    Label? apellidosDueno,
    LabelInt? dniDueno,
    Email? emailDueno,
    Number? telefonoDueno,
  }) =>
      OwnerFormState(
        isPosting: isPosting ?? this.isPosting,
        isFormPosted: isFormPosted ?? this.isFormPosted,
        isValid: isValid ?? this.isValid,
        nombresDueno: nombresDueno ?? this.nombresDueno,
        apellidosDueno: apellidosDueno ?? this.apellidosDueno,
        dniDueno: dniDueno ?? this.dniDueno,
        emailDueno: emailDueno ?? this.emailDueno,
        telefonoDueno: telefonoDueno ?? this.telefonoDueno,
      );
}
