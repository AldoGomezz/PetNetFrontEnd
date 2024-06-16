import 'package:formz/formz.dart';
import 'package:pet_net_app/core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_net_app/features/owner/domain/domain.dart';
import 'package:pet_net_app/features/owner/presentation/presentation.dart';

//StateNotifierProvider
final ownerUpdateFormProvider =
    StateNotifierProvider<OwnerUpdateFormNotifier, OwnerUpdateFormState>((ref) {
  return OwnerUpdateFormNotifier(ref: ref);
});

//Notifier

class OwnerUpdateFormNotifier extends StateNotifier<OwnerUpdateFormState> {
  Ref ref;
  OwnerUpdateFormNotifier({
    required this.ref,
  }) : super(OwnerUpdateFormState());

  void logout() {
    state = OwnerUpdateFormState();
  }

  setData(OwnerModel owner) {
    state = OwnerUpdateFormState(
      id: owner.id!,
      nombresDueno: Label.dirty(owner.firstName ?? ""),
      apellidosDueno: Label.dirty(owner.lastName ?? ""),
      dniDueno: LabelInt.dirty(owner.document ?? ""),
      emailDueno: Email.dirty(owner.email ?? ""),
      telefonoDueno: Number.dirty(owner.phoneNumber ?? ""),
    );
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
    if (!state.isValid || state.id == 0) return;
    state = state.copyWith(isPosting: true);
    await ref.read(ownerUpdateProvider.notifier).update(
          state.id,
          OwnerFormRequest(
            firstName: state.nombresDueno.value,
            lastName: state.apellidosDueno.value,
            document: state.dniDueno.value,
            email: state.emailDueno.value,
            phoneNumber: state.telefonoDueno.value,
          ),
        );
    await ref.read(ownerGetProvider.notifier).get(state.id);
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

class OwnerUpdateFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final int id;
  final Label nombresDueno;
  final Label apellidosDueno;
  final LabelInt dniDueno;
  final Email emailDueno;
  final Number telefonoDueno;

  OwnerUpdateFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.id = 0,
    this.nombresDueno = const Label.pure(),
    this.apellidosDueno = const Label.pure(),
    this.dniDueno = const LabelInt.pure(),
    this.emailDueno = const Email.pure(),
    this.telefonoDueno = const Number.pure(),
  });

  OwnerUpdateFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    int? id,
    Label? nombresDueno,
    Label? apellidosDueno,
    LabelInt? dniDueno,
    Email? emailDueno,
    Number? telefonoDueno,
  }) =>
      OwnerUpdateFormState(
        isPosting: isPosting ?? this.isPosting,
        isFormPosted: isFormPosted ?? this.isFormPosted,
        isValid: isValid ?? this.isValid,
        id: id ?? this.id,
        nombresDueno: nombresDueno ?? this.nombresDueno,
        apellidosDueno: apellidosDueno ?? this.apellidosDueno,
        dniDueno: dniDueno ?? this.dniDueno,
        emailDueno: emailDueno ?? this.emailDueno,
        telefonoDueno: telefonoDueno ?? this.telefonoDueno,
      );
}
