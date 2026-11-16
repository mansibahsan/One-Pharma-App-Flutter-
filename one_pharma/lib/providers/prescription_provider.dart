import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/prescription_model.dart';
import '../data/models/product_model.dart';
import '../data/mock/mock_data.dart';

class PrescriptionNotifier extends StateNotifier<List<PrescriptionModel>> {
  PrescriptionNotifier() : super(MockData.initialPrescriptions);

  void addPrescription(PrescriptionModel rx) {
    state = [rx, ...state];
  }

  void verifyPrescription(
    String id, {
    String? doctorName,
    String? doctorSpecialty,
    String? hospital,
    List<ProductModel>? linkedMedicines,
    String? notes,
  }) {
    state = state.map((rx) {
      if (rx.id != id) return rx;
      return rx.copyWith(
        status: PrescriptionStatus.verified,
        doctorName: doctorName ?? 'Dr. Tanjila Ahmed, PharmD',
        doctorSpecialty: doctorSpecialty ?? 'Clinical Pharmacist Specialist',
        hospital: hospital ?? 'Evercare Hospital Dhaka',
        linkedMedicines: linkedMedicines ?? rx.linkedMedicines,
        notes: notes ?? rx.notes,
        expiryDate: DateTime.now().add(const Duration(days: 60)),
      );
    }).toList();
  }

  void removePrescription(String id) {
    state = state.where((rx) => rx.id != id).toList();
  }

  void setPrescriptions(List<PrescriptionModel> list) {
    state = list;
  }
}

final prescriptionProvider =
    StateNotifierProvider<PrescriptionNotifier, List<PrescriptionModel>>((ref) {
  return PrescriptionNotifier();
});
