class PharmacistModel {
  final String id;
  final String name;
  final String qualification;
  final String designation;
  final double rating;
  final int reviewCount;
  final int experienceYears;
  final double consultationFee;
  final String avatarUrl;
  final bool isOnline;
  final String about;
  final List<String> availableSlots;
  final List<String> languages;

  const PharmacistModel({
    required this.id,
    required this.name,
    required this.qualification,
    required this.designation,
    required this.rating,
    required this.reviewCount,
    required this.experienceYears,
    required this.consultationFee,
    required this.avatarUrl,
    this.isOnline = true,
    required this.about,
    required this.availableSlots,
    this.languages = const ['English', 'Bengali'],
  });
}
