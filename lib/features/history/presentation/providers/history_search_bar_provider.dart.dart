import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_net_app/features/owner/presentation/presentation.dart';
import 'package:pet_net_app/features/patient/presentation/presentation.dart';

final historySearchBarProvider =
    StateNotifierProvider<HistorySearchBarNotifier, HistorySearchBarState>(
  (ref) => HistorySearchBarNotifier(ref),
);

class HistorySearchBarNotifier extends StateNotifier<HistorySearchBarState> {
  final Ref ref;
  HistorySearchBarNotifier(this.ref) : super(HistorySearchBarState());

  onSearchTypeChange(SearchType searchType) async {
    final newSearchType = searchType;
    state = state.copyWith(searchType: newSearchType);

    if (newSearchType == SearchType.owner) {
      await ref.read(ownerSearchProvider.notifier).search();
    } else {
      await ref.read(patientSearchProvider.notifier).search();
    }
  }

  onSearchBarChange(String query) async {
    final newSearchBar = query;
    state = state.copyWith(searchQuery: newSearchBar);

    if (state.searchType == SearchType.owner) {
      await ref.read(ownerSearchProvider.notifier).searchByQuery(newSearchBar);
    } else {
      await ref
          .read(patientSearchProvider.notifier)
          .searchByQuery(newSearchBar);
    }
  }

  onSearchSubmit(SearchType search) async {
    state = state.copyWith(isPosting: true);

    if (state.searchType == SearchType.owner) {
      await ref
          .read(ownerSearchProvider.notifier)
          .searchByQuery(state.searchQuery);
    } else {
      await ref
          .read(patientSearchProvider.notifier)
          .searchByQuery(state.searchQuery);
    }

    state = state.copyWith(isPosting: false);
  }

  void logout() {
    state = HistorySearchBarState();
  }
}

enum SearchType { owner, patient }

class HistorySearchBarState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final SearchType searchType;
  final String searchQuery;

  HistorySearchBarState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.searchQuery = "",
    this.searchType = SearchType.patient,
  });

  HistorySearchBarState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    SearchType? searchType,
    String? searchQuery,
  }) =>
      HistorySearchBarState(
        isPosting: isPosting ?? this.isPosting,
        isFormPosted: isFormPosted ?? this.isFormPosted,
        isValid: isValid ?? this.isValid,
        searchType: searchType ?? this.searchType,
        searchQuery: searchQuery ?? this.searchQuery,
      );
}
