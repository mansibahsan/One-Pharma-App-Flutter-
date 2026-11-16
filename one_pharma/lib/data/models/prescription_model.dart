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
  final String patientName;
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
    this.patientName = 'Hera Rahman',
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

  PrescriptionModel copyWith({
    String? id,
    String? title,
    String? patientName,
    String? doctorName,
    String? doctorSpecialty,
    String? hospital,
    DateTime? issueDate,
    DateTime? expiryDate,
    PrescriptionStatus? status,
    String? fileUrl,
    List<ProductModel>? linkedMedicines,
    String? notes,
  }) {
    return PrescriptionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      patientName: patientName ?? this.patientName,
      doctorName: doctorName ?? this.doctorName,
      doctorSpecialty: doctorSpecialty ?? this.doctorSpecialty,
      hospital: hospital ?? this.hospital,
      issueDate: issueDate ?? this.issueDate,
      expiryDate: expiryDate ?? this.expiryDate,
      status: status ?? this.status,
      fileUrl: fileUrl ?? this.fileUrl,
      linkedMedicines: linkedMedicines ?? this.linkedMedicines,
      notes: notes ?? this.notes,
    );
  }
}
