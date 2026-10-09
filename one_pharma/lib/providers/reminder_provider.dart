import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/reminder_model.dart';
import '../data/mock/mock_data.dart';

class ReminderNotifier extends StateNotifier<List<ReminderModel>> {
  ReminderNotifier() : super(MockData.initialReminders);

  void toggleTaken(String id) {
    state = state.map((r) {
      if (r.id == id) {
        final newTaken = !r.isTakenToday;
        final newRemaining = newTaken
            ? (r.remainingDoses > 0 ? r.remainingDoses - 1 : 0)
            : r.remainingDoses + 1;
        return r.copyWith(
          isTakenToday: newTaken,
          remainingDoses: newRemaining,
        );
      }
      return r;
    }).toList();
  }

  void addReminder(ReminderModel rem) {
    state = [...state, rem];
  }

  void setReminders(List<ReminderModel> list) {
    state = list;
  }
}

final reminderProvider =
    StateNotifierProvider<ReminderNotifier, List<ReminderModel>>((ref) {
  return ReminderNotifier();
});
