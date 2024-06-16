import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_net_app/core/core.dart';
import 'package:pet_net_app/features/history/presentation/presentation.dart';
import 'package:pet_net_app/features/owner/presentation/presentation.dart';
import 'package:pet_net_app/features/patient/presentation/presentation.dart';

class HistoriasClinicasContent extends ConsumerStatefulWidget {
  const HistoriasClinicasContent({super.key});

  @override
  HistoriasClinicasContentState createState() =>
      HistoriasClinicasContentState();
}

class HistoriasClinicasContentState
    extends ConsumerState<HistoriasClinicasContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(patientSearchProvider.notifier).search();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final historySearchBarState = ref.watch(historySearchBarProvider);
    final patientSearchPv = ref.watch(patientSearchProvider);
    final ownerState = ref.watch(ownerSearchProvider);
    return SizedBox(
      width: size.width,
      height: size.height,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(height: size.height * 0.05),
            Center(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  "Historias Clínicas",
                  style: getTitleBoldStyle(context),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: size.height * 0.03),
            const TopBarHistorias(),
            SizedBox(height: size.height * 0.03),
            /*   _buildBody(), */
            Flexible(
              child: _buildBody(
                historySearchBarState,
                ownerState,
                patientSearchPv,
                ref,
              ),
            ),
            /* patientSearchPv.patients.isNotEmpty
                ? */
            Column(
              children: [
                SizedBox(height: size.height * 0.01),
                Center(
                  child: CustomFilledButton(
                    text: "Nuevo Dueño",
                    style: getSubtitleBoldStyle(context).copyWith(
                      color: Colors.white,
                    ),
                    onPressed: () {
                      ref.read(ownerFormProvider.notifier).logout();
                      context.push("/owner-form");
                    },
                  ),
                ),
              ],
            )
            /* : Container(), */
          ],
        ),
      ),
    );
  }

  Widget _buildBody(
    HistorySearchBarState historySearchBarState,
    OwnerSearchState ownerState,
    PatientSearchState patientState,
    WidgetRef ref,
  ) {
    if (patientState.isLoading || ownerState.isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      );
    } else if (patientState.error.type != null ||
        ownerState.error.type != null) {
      switch (historySearchBarState.searchType) {
        case SearchType.owner:
          return RetryWidget(
            errorMessage: ownerState.error.message != null
                ? ownerState.error.message!
                : getErrorMessage(ownerState.error, context),
            onPressed: () {
              ref.read(ownerSearchProvider.notifier).search();
            },
          );
        case SearchType.patient:
          return RetryWidget(
            errorMessage: patientState.error.message != null
                ? patientState.error.message!
                : getErrorMessage(patientState.error, context),
            onPressed: () {
              ref.read(patientSearchProvider.notifier).search();
            },
          );
      }
    } else if (patientState.patients.isNotEmpty ||
        ownerState.owners.isNotEmpty) {
      final itemCount = historySearchBarState.searchType == SearchType.owner
          ? ownerState.owners.length
          : patientState.patients.length;

      return GridView.builder(
        padding: EdgeInsets.zero,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 25,
          mainAxisSpacing: 25,
        ),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          switch (historySearchBarState.searchType) {
            case SearchType.owner:
              return OwnerCard(
                owner: ownerState.owners[index],
              );
            case SearchType.patient:
              return PatientCard(
                patient: patientState.patients[index],
              );
            default:
          }
          return null;
        },
      );
    } else {
      return const Center(
        child: Text("No se encontraron resultados"),
      );
    }
  }
}
