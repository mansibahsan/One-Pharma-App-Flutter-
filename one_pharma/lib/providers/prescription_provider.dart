import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/prescription_model.dart';
import '../data/mock/mock_data.dart';

class PrescriptionNotifier extends StateNotifier<List<PrescriptionModel>> {
  PrescriptionNotifier() : super(MockData.initialPrescriptions);

  void addPrescription(PrescriptionModel rx) {
    state = [rx, ...state];
  }

  void setPrescriptions(List<PrescriptionModel> list) {
    state = list;
  }
}

final prescriptionProvider =
    StateNotifierProvider<PrescriptionNotifier, List<PrescriptionModel>>((ref) {
  return PrescriptionNotifier();
});
