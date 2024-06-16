import 'dart:typed_data';
import 'package:formz/formz.dart';
import 'package:pet_net_app/core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_net_app/features/patient/domain/domain.dart';
import 'package:pet_net_app/features/patient/presentation/presentation.dart';

//StateNotifierProvider
final patientGenerateFormProvider = StateNotifierProvider<
    PatientGenerateFormNotifier, PatientGenerateFormState>((ref) {
  return PatientGenerateFormNotifier(ref: ref);
});

//Notifier

class PatientGenerateFormNotifier
    extends StateNotifier<PatientGenerateFormState> {
  Ref ref;
  PatientGenerateFormNotifier({
    required this.ref,
  }) : super(PatientGenerateFormState());

  void logout() {
    state = PatientGenerateFormState();
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
        state.mascota,
        state.edad,
        state.peso,
        state.comentario,
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
        state.mascota,
        state.edad,
        state.peso,
        state.comentario,
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
        state.mascota,
        state.edad,
        state.peso,
        state.comentario,
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
        state.mascota,
        state.edad,
        state.peso,
        state.comentario,
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
        state.mascota,
        state.edad,
        state.peso,
        state.comentario,
      ]),
    );
  }

  onMascotaChanged(String value) {
    final mascota = Label.dirty(value);
    state = state.copyWith(
      mascota: mascota,
      isValid: Formz.validate([
        state.nombresDueno,
        state.apellidosDueno,
        state.dniDueno,
        state.emailDueno,
        state.telefonoDueno,
        mascota,
        state.edad,
        state.peso,
        state.comentario,
      ]),
    );
  }

  onEdadChanged(String value) {
    final edad = LabelInt.dirty(value);
    state = state.copyWith(
      edad: edad,
      isValid: Formz.validate([
        state.nombresDueno,
        state.apellidosDueno,
        state.dniDueno,
        state.emailDueno,
        state.telefonoDueno,
        state.mascota,
        edad,
        state.peso,
        state.comentario,
      ]),
    );
  }

  onPesoChanged(String value) {
    final peso = LabelInt.dirty(value);
    state = state.copyWith(
      peso: peso,
      isValid: Formz.validate([
        state.nombresDueno,
        state.apellidosDueno,
        state.dniDueno,
        state.emailDueno,
        state.telefonoDueno,
        state.mascota,
        state.edad,
        peso,
        state.comentario,
      ]),
    );
  }

  onComentarioChanged(String value) {
    final comentario = Label.dirty(value);
    state = state.copyWith(
      comentario: comentario,
      isValid: Formz.validate([
        state.nombresDueno,
        state.apellidosDueno,
        state.dniDueno,
        state.emailDueno,
        state.telefonoDueno,
        state.mascota,
        state.edad,
        state.peso,
        comentario,
      ]),
    );
  }

  onProfilePhotoChanged(Uint8List? value) {
    state = state.copyWith(profilePhoto: value);
  }

  onProfilePhotoNameChanged(String? value) {
    state = state.copyWith(profilePhotoName: value);
  }

  onAnalyzedPhotoChanged(Uint8List? value) {
    state = state.copyWith(analyzedPhoto: value);
  }

  onAnalyzedPhotoNameChanged(String? value) {
    state = state.copyWith(analyzedPhotoName: value);
  }

  onClassNameChanged(String value) {
    state = state.copyWith(className: value);
  }

  onProbabilityChanged(String value) {
    state = state.copyWith(probability: value);
  }

  onFormSubmit() async {
    _touchEveryField();
    if (!state.isValid) return;
    state = state.copyWith(isPosting: true);
    await ref.read(patientGenerateProvider.notifier).patientGenerate(
          PatientGenerateRequest(
            firstName: state.nombresDueno.value,
            lastName: state.apellidosDueno.value,
            email: state.emailDueno.value,
            phoneNumber: state.telefonoDueno.value,
            document: state.dniDueno.value,
            nickname: state.mascota.value,
            age: int.parse(state.edad.value),
            weight: int.parse(state.peso.value),
            profilePhoto: state.profilePhoto!,
            profilePhotoName: state.profilePhotoName!,
            analyzedPhoto: state.analyzedPhoto!,
            analyzedPhotoName: state.analyzedPhotoName!,
            description: state.comentario.value,
            className: state.className!,
            probability: state.probability!,
          ),
        );
    state = state.copyWith(isPosting: false);
  }

  _touchEveryField() {
    final nombresDueno = Label.dirty(state.nombresDueno.value);
    final apellidosDueno = Label.dirty(state.apellidosDueno.value);
    final dniDueno = LabelInt.dirty(state.dniDueno.value);
    final emailDueno = Email.dirty(state.emailDueno.value);
    final telefonoDueno = Number.dirty(state.telefonoDueno.value);
    final mascota = Label.dirty(state.mascota.value);
    final edad = LabelInt.dirty(state.edad.value);
    final peso = LabelInt.dirty(state.peso.value);
    final comentario = Label.dirty(state.comentario.value);

    state = state.copyWith(
      isFormPosted: true,
      nombresDueno: nombresDueno,
      apellidosDueno: apellidosDueno,
      dniDueno: dniDueno,
      emailDueno: emailDueno,
      telefonoDueno: telefonoDueno,
      mascota: mascota,
      edad: edad,
      peso: peso,
      comentario: comentario,
      isValid: Formz.validate([
        nombresDueno,
        apellidosDueno,
        dniDueno,
        emailDueno,
        telefonoDueno,
        mascota,
        edad,
        peso,
        comentario,
      ]),
    );
  }
}

//State

class PatientGenerateFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Uint8List? profilePhoto;
  final String? profilePhotoName;
  final Uint8List? analyzedPhoto;
  final String? analyzedPhotoName;
  final Label nombresDueno;
  final Label apellidosDueno;
  final LabelInt dniDueno;
  final Email emailDueno;
  final Number telefonoDueno;
  final Label mascota;
  final LabelInt edad;
  final LabelInt peso;
  final Label comentario;
  final String? className;
  final String? probability;

  PatientGenerateFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.profilePhoto,
    this.profilePhotoName,
    this.analyzedPhoto,
    this.analyzedPhotoName,
    this.nombresDueno = const Label.pure(),
    this.apellidosDueno = const Label.pure(),
    this.dniDueno = const LabelInt.pure(),
    this.emailDueno = const Email.pure(),
    this.telefonoDueno = const Number.pure(),
    this.mascota = const Label.pure(),
    this.edad = const LabelInt.pure(),
    this.peso = const LabelInt.pure(),
    this.comentario = const Label.pure(),
    this.className,
    this.probability,
  });

  PatientGenerateFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Uint8List? profilePhoto,
    String? profilePhotoName,
    Uint8List? analyzedPhoto,
    String? analyzedPhotoName,
    Label? nombresDueno,
    Label? apellidosDueno,
    LabelInt? dniDueno,
    Email? emailDueno,
    Number? telefonoDueno,
    Label? mascota,
    LabelInt? edad,
    LabelInt? peso,
    Label? comentario,
    String? className,
    String? probability,
  }) =>
      PatientGenerateFormState(
        isPosting: isPosting ?? this.isPosting,
        isFormPosted: isFormPosted ?? this.isFormPosted,
        isValid: isValid ?? this.isValid,
        profilePhoto: profilePhoto ?? this.profilePhoto,
        profilePhotoName: profilePhotoName ?? this.profilePhotoName,
        analyzedPhoto: analyzedPhoto ?? this.analyzedPhoto,
        analyzedPhotoName: analyzedPhotoName ?? this.analyzedPhotoName,
        nombresDueno: nombresDueno ?? this.nombresDueno,
        apellidosDueno: apellidosDueno ?? this.apellidosDueno,
        dniDueno: dniDueno ?? this.dniDueno,
        emailDueno: emailDueno ?? this.emailDueno,
        telefonoDueno: telefonoDueno ?? this.telefonoDueno,
        mascota: mascota ?? this.mascota,
        edad: edad ?? this.edad,
        peso: peso ?? this.peso,
        comentario: comentario ?? this.comentario,
        className: className ?? this.className,
        probability: probability ?? this.probability,
      );
}
