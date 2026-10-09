class PharmacyModel {
  final String id;
  final String name;
  final String address;
  final double rating;
  final int reviewCount;
  final double distanceKm;
  final bool isOpen;
  final String openingHours;
  final String phone;
  final double latitudeOffset;
  final double longitudeOffset;

  const PharmacyModel({
    required this.id,
    required this.name,
    required this.address,
    required this.rating,
    required this.reviewCount,
    required this.distanceKm,
    required this.isOpen,
    required this.openingHours,
    required this.phone,
    required this.latitudeOffset,
    required this.longitudeOffset,
  });
}
