class AddressModel {
  final String id;
  final String label; // 'Home', 'Office', 'Parents'
  final String recipientName;
  final String phone;
  final String streetAddress;
  final String area;
  final String city;
  final bool isDefault;

  const AddressModel({
    required this.id,
    required this.label,
    required this.recipientName,
    required this.phone,
    required this.streetAddress,
    required this.area,
    this.city = 'Dhaka 1230',
    this.isDefault = false,
  });

  String get fullAddress => '$streetAddress, $area, $city';

  AddressModel copyWith({
    String? id,
    String? label,
    String? recipientName,
    String? phone,
    String? streetAddress,
    String? area,
    String? city,
    bool? isDefault,
  }) {
    return AddressModel(
      id: id ?? this.id,
      label: label ?? this.label,
      recipientName: recipientName ?? this.recipientName,
      phone: phone ?? this.phone,
      streetAddress: streetAddress ?? this.streetAddress,
      area: area ?? this.area,
      city: city ?? this.city,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}
