import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_net_app/features/patient/domain/domain.dart';
import 'package:pet_net_app/features/patient/presentation/presentation.dart';

//StateNotifierProvider
final patientUpdateImageFormProvider = StateNotifierProvider<
    PatientUpdateImageFormNotifier, PatientUpdateImageFormState>((ref) {
  return PatientUpdateImageFormNotifier(ref: ref);
});

//Notifier

class PatientUpdateImageFormNotifier
    extends StateNotifier<PatientUpdateImageFormState> {
  Ref ref;
  PatientUpdateImageFormNotifier({
    required this.ref,
  }) : super(PatientUpdateImageFormState());

  void logout() {
    state = PatientUpdateImageFormState();
  }

  setData(PatientModel patient) {
    state = PatientUpdateImageFormState(
      patientId: patient.id,
      profilePhotoUrl: patient.profilePhoto,
    );
  }

  onProfilePhotoChanged(Uint8List? value) {
    state = state.copyWith(profilePhoto: value);
  }

  onProfilePhotoNameChanged(String? value) {
    state = state.copyWith(profilePhotoName: value);
  }

  onFormSubmit() async {
    state = state.copyWith(isPosting: true);
    if (state.patientId == 0 || state.profilePhoto == null) {
      state = state.copyWith(isPosting: false);
      return;
    }
    await ref.read(patientUpdateImageProvider.notifier).updateImage(
          state.patientId,
          state.profilePhoto!,
          state.profilePhotoName!,
        );
    await ref.read(patientGetProvider.notifier).get(state.patientId);

    state = state.copyWith(isPosting: false);
  }
}

//State

class PatientUpdateImageFormState {
  final bool isPosting;
  final bool isFormPosted;
  final int patientId;
  final String profilePhotoUrl;
  final Uint8List? profilePhoto;
  final String? profilePhotoName;
  PatientUpdateImageFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.patientId = 0,
    this.profilePhotoUrl = '',
    this.profilePhoto,
    this.profilePhotoName,
  });

  PatientUpdateImageFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    int? patientId,
    String? profilePhotoUrl,
    Uint8List? profilePhoto,
    String? profilePhotoName,
  }) =>
      PatientUpdateImageFormState(
        isPosting: isPosting ?? this.isPosting,
        isFormPosted: isFormPosted ?? this.isFormPosted,
        patientId: patientId ?? this.patientId,
        profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
        profilePhoto: profilePhoto ?? this.profilePhoto,
        profilePhotoName: profilePhotoName ?? this.profilePhotoName,
      );
}
