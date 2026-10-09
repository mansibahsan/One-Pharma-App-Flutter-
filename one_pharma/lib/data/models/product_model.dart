class ProductModel {
  final String id;
  final String name;
  final String genericName;
  final String brand;
  final String category;
  final String selectedStrength;
  final List<String> availableStrengths;
  final double price;
  final double originalPrice;
  final int discountPercent;
  final double rating;
  final int reviewCount;
  final bool isPrescriptionRequired;
  final String description;
  final String indications;
  final String precautions;
  final String packagingInfo;
  final int inStock;
  final int iconIndex;
  final String? imageUrl;
  final List<String> images;

  const ProductModel({
    required this.id,
    required this.name,
    required this.genericName,
    required this.brand,
    required this.category,
    required this.selectedStrength,
    required this.availableStrengths,
    required this.price,
    required this.originalPrice,
    required this.discountPercent,
    required this.rating,
    required this.reviewCount,
    required this.isPrescriptionRequired,
    required this.description,
    required this.indications,
    required this.precautions,
    this.packagingInfo = 'Bottle of 150 tablets',
    this.inStock = 50,
    this.iconIndex = 0,
    this.imageUrl,
    this.images = const [],
  });

  List<String> get allImages {
    if (images.isNotEmpty) return images;
    if (imageUrl != null && imageUrl!.isNotEmpty) return [imageUrl!];
    return const [];
  }

  ProductModel copyWith({
    String? id,
    String? name,
    String? genericName,
    String? brand,
    String? category,
    String? selectedStrength,
    List<String>? availableStrengths,
    double? price,
    double? originalPrice,
    int? discountPercent,
    double? rating,
    int? reviewCount,
    bool? isPrescriptionRequired,
    String? description,
    String? indications,
    String? precautions,
    String? packagingInfo,
    int? inStock,
    int? iconIndex,
    String? imageUrl,
    List<String>? images,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      genericName: genericName ?? this.genericName,
      brand: brand ?? this.brand,
      category: category ?? this.category,
      selectedStrength: selectedStrength ?? this.selectedStrength,
      availableStrengths: availableStrengths ?? this.availableStrengths,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      discountPercent: discountPercent ?? this.discountPercent,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isPrescriptionRequired: isPrescriptionRequired ?? this.isPrescriptionRequired,
      description: description ?? this.description,
      indications: indications ?? this.indications,
      precautions: precautions ?? this.precautions,
      packagingInfo: packagingInfo ?? this.packagingInfo,
      inStock: inStock ?? this.inStock,
      iconIndex: iconIndex ?? this.iconIndex,
      imageUrl: imageUrl ?? this.imageUrl,
      images: images ?? this.images,
    );
  }
}
