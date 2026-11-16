import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/pharmacist_model.dart';
import '../data/mock/mock_data.dart';

class ConsultationNotifier extends StateNotifier<List<PharmacistModel>> {
  ConsultationNotifier() : super(MockData.pharmacists);

  void toggleOnlineStatus(String pharmacistId) {
    state = state.map((doc) {
      if (doc.id != pharmacistId) return doc;
      return PharmacistModel(
        id: doc.id,
        name: doc.name,
        qualification: doc.qualification,
        designation: doc.designation,
        rating: doc.rating,
        reviewCount: doc.reviewCount,
        experienceYears: doc.experienceYears,
        consultationFee: doc.consultationFee,
        avatarUrl: doc.avatarUrl,
        isOnline: !doc.isOnline,
        about: doc.about,
        availableSlots: doc.availableSlots,
        languages: doc.languages,
      );
    }).toList();
  }

  void toggleSlot(String pharmacistId, String slot) {
    state = state.map((doc) {
      if (doc.id != pharmacistId) return doc;
      final current = List<String>.from(doc.availableSlots);
      if (current.contains(slot)) {
        if (current.length > 1) {
          current.remove(slot);
        }
      } else {
        current.add(slot);
      }
      return PharmacistModel(
        id: doc.id,
        name: doc.name,
        qualification: doc.qualification,
        designation: doc.designation,
        rating: doc.rating,
        reviewCount: doc.reviewCount,
        experienceYears: doc.experienceYears,
        consultationFee: doc.consultationFee,
        avatarUrl: doc.avatarUrl,
        isOnline: doc.isOnline,
        about: doc.about,
        availableSlots: current,
        languages: doc.languages,
      );
    }).toList();
  }
}

final pharmacistListProvider =
    StateNotifierProvider<ConsultationNotifier, List<PharmacistModel>>((ref) {
  return ConsultationNotifier();
});

enum AppointmentStatus {
  upcoming,
  completed;

  String get label {
    switch (this) {
      case AppointmentStatus.upcoming:
        return 'Upcoming';
      case AppointmentStatus.completed:
        return 'Completed';
    }
  }
}

class BookedAppointment {
  final String id;
  final PharmacistModel pharmacist;
  final String patientName;
  final String patientAgeGender;
  final String chiefComplaint;
  final String mode;
  final String date;
  final String time;
  final AppointmentStatus status;

  const BookedAppointment({
    required this.id,
    required this.pharmacist,
    this.patientName = 'Hera Rahman',
    this.patientAgeGender = '29 yrs • Female',
    this.chiefComplaint = 'Medication dosage review & antibiotic guidance',
    this.mode = 'Video Call',
    required this.date,
    required this.time,
    this.status = AppointmentStatus.upcoming,
  });

  BookedAppointment copyWith({
    AppointmentStatus? status,
    String? chiefComplaint,
  }) {
    return BookedAppointment(
      id: id,
      pharmacist: pharmacist,
      patientName: patientName,
      patientAgeGender: patientAgeGender,
      chiefComplaint: chiefComplaint ?? this.chiefComplaint,
      mode: mode,
      date: date,
      time: time,
      status: status ?? this.status,
    );
  }
}

class AppointmentsNotifier extends StateNotifier<List<BookedAppointment>> {
  AppointmentsNotifier()
      : super([
          BookedAppointment(
            id: 'appt_seed_1',
            pharmacist: MockData.pharmacists[0],
            patientName: 'Hera Rahman',
            patientAgeGender: '29 yrs • Female',
            chiefComplaint: 'Lantus Insulin Pen titration & fasting glucose log review',
            mode: 'Video Call',
            date: 'Today',
            time: '10:00 AM',
            status: AppointmentStatus.upcoming,
          ),
          BookedAppointment(
            id: 'appt_seed_2',
            pharmacist: MockData.pharmacists[0],
            patientName: 'Rafiqul Rahman',
            patientAgeGender: '64 yrs • Male',
            chiefComplaint: 'Post-hospital IV Normal Saline & Ceftriaxone schedule',
            mode: 'Audio Call',
            date: 'Today',
            time: '11:30 AM',
            status: AppointmentStatus.upcoming,
          ),
          BookedAppointment(
            id: 'appt_seed_3',
            pharmacist: MockData.pharmacists[0],
            patientName: 'Nadia Islam',
            patientAgeGender: '34 yrs • Female',
            chiefComplaint: 'Seasonal cough syrup & antihistamine compatibility',
            mode: 'Video Call',
            date: 'Yesterday',
            time: '04:30 PM',
            status: AppointmentStatus.completed,
          ),
        ]);

  void book(
    PharmacistModel pharmacist,
    String date,
    String time, {
    String patientName = 'Hera Rahman',
    String mode = 'Video Call',
    String chiefComplaint = 'Clinical consultation & prescription review',
  }) {
    final appt = BookedAppointment(
      id: 'appt_${DateTime.now().millisecondsSinceEpoch}',
      pharmacist: pharmacist,
      patientName: patientName,
      mode: mode,
      chiefComplaint: chiefComplaint,
      date: date,
      time: time,
      status: AppointmentStatus.upcoming,
    );
    state = [appt, ...state];
  }

  void markCompleted(String id) {
    state = state.map((a) {
      if (a.id != id) return a;
      return a.copyWith(status: AppointmentStatus.completed);
    }).toList();
  }
}

final appointmentsProvider =
    StateNotifierProvider<AppointmentsNotifier, List<BookedAppointment>>((ref) {
  return AppointmentsNotifier();
});
