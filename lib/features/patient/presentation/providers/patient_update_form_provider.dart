import 'package:formz/formz.dart';
import 'package:pet_net_app/core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_net_app/features/patient/domain/domain.dart';
import 'package:pet_net_app/features/patient/presentation/presentation.dart';

//StateNotifierProvider
final patientUpdateFormProvider =
    StateNotifierProvider<PatientUpdateFormNotifier, PatientUpdateFormState>(
        (ref) {
  return PatientUpdateFormNotifier(ref: ref);
});

//Notifier

class PatientUpdateFormNotifier extends StateNotifier<PatientUpdateFormState> {
  Ref ref;
  PatientUpdateFormNotifier({
    required this.ref,
  }) : super(PatientUpdateFormState());

  void logout() {
    state = PatientUpdateFormState();
  }

  void setPatientId(int patientId) {
    state = state.copyWith(patientId: patientId);
  }

  setData(PatientModel patient) {
    state = PatientUpdateFormState(
      patientId: patient.id,
      mascota: Label.dirty(patient.nickname),
      edad: LabelInt.dirty(patient.age.toString()),
      peso: LabelInt.dirty(patient.weight.toInt().toString()),
    );
  }

  onMascotaChanged(String value) {
    final mascota = Label.dirty(value);
    state = state.copyWith(
      mascota: mascota,
      isValid: Formz.validate([
        mascota,
        state.edad,
        state.peso,
      ]),
    );
  }

  onEdadChanged(String value) {
    final edad = LabelInt.dirty(value);
    state = state.copyWith(
      edad: edad,
      isValid: Formz.validate([
        state.mascota,
        edad,
        state.peso,
      ]),
    );
  }

  onPesoChanged(String value) {
    final peso = LabelInt.dirty(value);
    state = state.copyWith(
      peso: peso,
      isValid: Formz.validate([
        state.mascota,
        state.edad,
        peso,
      ]),
    );
  }

  onFormSubmit() async {
    _touchEveryField();
    if (!state.isValid || state.patientId == 0) return;
    state = state.copyWith(isPosting: true);
    await ref.read(patientUpdateProvider.notifier).update(
          PatientUpdateRequest(
            nickname: state.mascota.value,
            age: int.parse(state.edad.value),
            weight: int.parse(state.peso.value),
          ),
          state.patientId,
        );
    await ref.read(patientGetProvider.notifier).get(state.patientId);
    state = state.copyWith(isPosting: false);
  }

  _touchEveryField() {
    final mascota = Label.dirty(state.mascota.value);
    final edad = LabelInt.dirty(state.edad.value);
    final peso = LabelInt.dirty(state.peso.value);

    state = state.copyWith(
      isFormPosted: true,
      mascota: mascota,
      edad: edad,
      peso: peso,
      isValid: Formz.validate([
        mascota,
        edad,
        peso,
      ]),
    );
  }
}

//State

class PatientUpdateFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final int patientId;
  final Label mascota;
  final LabelInt edad;
  final LabelInt peso;
  PatientUpdateFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.patientId = 0,
    this.mascota = const Label.pure(),
    this.edad = const LabelInt.pure(),
    this.peso = const LabelInt.pure(),
  });

  PatientUpdateFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    int? patientId,
    Label? mascota,
    LabelInt? edad,
    LabelInt? peso,
  }) =>
      PatientUpdateFormState(
        isPosting: isPosting ?? this.isPosting,
        isFormPosted: isFormPosted ?? this.isFormPosted,
        isValid: isValid ?? this.isValid,
        patientId: patientId ?? this.patientId,
        mascota: mascota ?? this.mascota,
        edad: edad ?? this.edad,
        peso: peso ?? this.peso,
      );
}
