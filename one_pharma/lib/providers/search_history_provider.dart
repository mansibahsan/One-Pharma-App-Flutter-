import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchHistoryNotifier extends StateNotifier<List<String>> {
  SearchHistoryNotifier()
      : super(const [
          'Betulin Lux',
          'Multivitamins',
          'Allergy Relief',
          'Ibuprofen',
          'Azithromycin',
        ]);

  void addQuery(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;
    state = [trimmed, ...state.where((q) => q.toLowerCase() != trimmed.toLowerCase())];
  }

  void removeQuery(String query) {
    state = state.where((q) => q != query).toList();
  }

  void clearAll() {
    state = const [];
  }
}

final searchHistoryProvider =
    StateNotifierProvider<SearchHistoryNotifier, List<String>>((ref) {
  return SearchHistoryNotifier();
});
