import 'product_model.dart';

enum PrescriptionStatus {
  verified,
  pending,
  expired;

  String get label {
    switch (this) {
      case PrescriptionStatus.verified:
        return 'Verified';
      case PrescriptionStatus.pending:
        return 'Under Review';
      case PrescriptionStatus.expired:
        return 'Expired';
    }
  }
}

class PrescriptionModel {
  final String id;
  final String title;
  final String doctorName;
  final String doctorSpecialty;
  final String hospital;
  final DateTime issueDate;
  final DateTime expiryDate;
  final PrescriptionStatus status;
  final String fileUrl;
  final List<ProductModel> linkedMedicines;
  final String notes;

  const PrescriptionModel({
    required this.id,
    required this.title,
    required this.doctorName,
    required this.doctorSpecialty,
    required this.hospital,
    required this.issueDate,
    required this.expiryDate,
    required this.status,
    required this.fileUrl,
    required this.linkedMedicines,
    this.notes = '',
  });

  bool get isValid =>
      status == PrescriptionStatus.verified && expiryDate.isAfter(DateTime.now());
}
