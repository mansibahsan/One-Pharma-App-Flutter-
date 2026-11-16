enum UserRole {
  patient,
  doctor;

  String get label {
    switch (this) {
      case UserRole.patient:
        return 'Patient';
      case UserRole.doctor:
        return 'Doctor';
    }
  }
}

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String role;
  final String avatarUrl;
  final UserRole userRole;
  final String specialty;
  final String licenseNumber;
  final String hospital;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    this.role = 'Verified Patient • Dhaka, BD',
    this.avatarUrl = '',
    this.userRole = UserRole.patient,
    this.specialty = '',
    this.licenseNumber = '',
    this.hospital = '',
  });

  bool get isDoctor => userRole == UserRole.doctor;

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? address,
    String? role,
    String? avatarUrl,
    UserRole? userRole,
    String? specialty,
    String? licenseNumber,
    String? hospital,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      role: role ?? this.role,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      userRole: userRole ?? this.userRole,
      specialty: specialty ?? this.specialty,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      hospital: hospital ?? this.hospital,
    );
  }
}
