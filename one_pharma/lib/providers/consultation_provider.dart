import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/pharmacist_model.dart';
import '../data/mock/mock_data.dart';

class ConsultationNotifier extends StateNotifier<List<PharmacistModel>> {
  ConsultationNotifier() : super(MockData.pharmacists);
}

final pharmacistListProvider =
    StateNotifierProvider<ConsultationNotifier, List<PharmacistModel>>((ref) {
  return ConsultationNotifier();
});

class BookedAppointment {
  final String id;
  final PharmacistModel pharmacist;
  final String date;
  final String time;

  const BookedAppointment({
    required this.id,
    required this.pharmacist,
    required this.date,
    required this.time,
  });
}

class AppointmentsNotifier extends StateNotifier<List<BookedAppointment>> {
  AppointmentsNotifier() : super(const []);

  void book(PharmacistModel pharmacist, String date, String time) {
    final appt = BookedAppointment(
      id: 'appt_\${DateTime.now().millisecondsSinceEpoch}',
      pharmacist: pharmacist,
      date: date,
      time: time,
    );
    state = [appt, ...state];
  }
}

final appointmentsProvider =
    StateNotifierProvider<AppointmentsNotifier, List<BookedAppointment>>((ref) {
  return AppointmentsNotifier();
});
