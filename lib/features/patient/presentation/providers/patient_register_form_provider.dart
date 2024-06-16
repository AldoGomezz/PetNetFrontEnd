import 'dart:typed_data';
import 'package:formz/formz.dart';
import 'package:pet_net_app/core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_net_app/features/owner/presentation/presentation.dart';
import 'package:pet_net_app/features/patient/domain/domain.dart';
import 'package:pet_net_app/features/patient/presentation/presentation.dart';

//StateNotifierProvider
final patientRegisterFormProvider = StateNotifierProvider<
    PatientRegisterFormNotifier, PatientRegisterFormState>((ref) {
  return PatientRegisterFormNotifier(ref: ref);
});

//Notifier

class PatientRegisterFormNotifier
    extends StateNotifier<PatientRegisterFormState> {
  Ref ref;
  PatientRegisterFormNotifier({
    required this.ref,
  }) : super(PatientRegisterFormState());

  void logout() {
    state = PatientRegisterFormState();
  }

  void setOwnerId(int ownerId) {
    state = state.copyWith(ownerId: ownerId);
  }

  setData(PatientModel patient) {
    state = PatientRegisterFormState(
      ownerId: patient.ownerId,
      mascota: Label.dirty(patient.nickname),
      edad: LabelInt.dirty(patient.age.toString()),
      peso: LabelInt.dirty(patient.weight.toString()),
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

  onProfilePhotoChanged(Uint8List? value) {
    state = state.copyWith(profilePhoto: value);
  }

  onProfilePhotoNameChanged(String? value) {
    state = state.copyWith(profilePhotoName: value);
  }

  onFormSubmit() async {
    _touchEveryField();
    if (!state.isValid || state.ownerId == 0) return;
    state = state.copyWith(isPosting: true);
    await ref.read(patientRegisterProvider.notifier).register(
          PatientRegisterRequest(
            ownerId: state.ownerId,
            nickname: state.mascota.value,
            age: int.parse(state.edad.value),
            weight: int.parse(state.peso.value),
            profilePhoto: state.profilePhoto!,
            profilePhotoName: state.profilePhotoName!,
          ),
        );
    await ref.read(ownerGetProvider.notifier).get(state.ownerId);
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

class PatientRegisterFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final int ownerId;
  final Uint8List? profilePhoto;
  final String? profilePhotoName;
  final Label mascota;
  final LabelInt edad;
  final LabelInt peso;
  PatientRegisterFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.ownerId = 0,
    this.profilePhoto,
    this.profilePhotoName,
    this.mascota = const Label.pure(),
    this.edad = const LabelInt.pure(),
    this.peso = const LabelInt.pure(),
  });

  PatientRegisterFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    int? ownerId,
    Uint8List? profilePhoto,
    String? profilePhotoName,
    Label? mascota,
    LabelInt? edad,
    LabelInt? peso,
  }) =>
      PatientRegisterFormState(
        isPosting: isPosting ?? this.isPosting,
        isFormPosted: isFormPosted ?? this.isFormPosted,
        isValid: isValid ?? this.isValid,
        ownerId: ownerId ?? this.ownerId,
        profilePhoto: profilePhoto ?? this.profilePhoto,
        profilePhotoName: profilePhotoName ?? this.profilePhotoName,
        mascota: mascota ?? this.mascota,
        edad: edad ?? this.edad,
        peso: peso ?? this.peso,
      );
}
