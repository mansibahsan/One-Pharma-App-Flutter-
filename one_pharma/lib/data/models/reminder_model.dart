import 'product_model.dart';

enum ReminderTimeSlot {
  morning,
  afternoon,
  evening,
  night;

  String get label {
    switch (this) {
      case ReminderTimeSlot.morning:
        return 'Morning';
      case ReminderTimeSlot.afternoon:
        return 'Afternoon';
      case ReminderTimeSlot.evening:
        return 'Evening';
      case ReminderTimeSlot.night:
        return 'Night';
    }
  }

  String get defaultTime {
    switch (this) {
      case ReminderTimeSlot.morning:
        return '08:00 AM';
      case ReminderTimeSlot.afternoon:
        return '01:30 PM';
      case ReminderTimeSlot.evening:
        return '06:00 PM';
      case ReminderTimeSlot.night:
        return '09:30 PM';
    }
  }
}

class ReminderModel {
  final String id;
  final ProductModel product;
  final String dosage;
  final String instruction; // 'After meal', 'Before meal'
  final ReminderTimeSlot slot;
  final String time;
  final bool isTakenToday;
  final int remainingDoses;
  final int totalDoses;

  const ReminderModel({
    required this.id,
    required this.product,
    required this.dosage,
    required this.instruction,
    required this.slot,
    required this.time,
    this.isTakenToday = false,
    required this.remainingDoses,
    required this.totalDoses,
  });

  bool get needsRefill => remainingDoses <= 6;

  ReminderModel copyWith({
    String? id,
    ProductModel? product,
    String? dosage,
    String? instruction,
    ReminderTimeSlot? slot,
    String? time,
    bool? isTakenToday,
    int? remainingDoses,
    int? totalDoses,
  }) {
    return ReminderModel(
      id: id ?? this.id,
      product: product ?? this.product,
      dosage: dosage ?? this.dosage,
      instruction: instruction ?? this.instruction,
      slot: slot ?? this.slot,
      time: time ?? this.time,
      isTakenToday: isTakenToday ?? this.isTakenToday,
      remainingDoses: remainingDoses ?? this.remainingDoses,
      totalDoses: totalDoses ?? this.totalDoses,
    );
  }
}
