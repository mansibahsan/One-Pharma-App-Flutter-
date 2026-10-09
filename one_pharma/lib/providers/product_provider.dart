import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/product_model.dart';
import '../data/mock/mock_data.dart';

enum SortOption {
  popular,
  costLowToHigh,
  costHighToLow,
  rating;

  String get label {
    switch (this) {
      case SortOption.popular:
        return 'Most Popular';
      case SortOption.costLowToHigh:
        return 'Cost low to high';
      case SortOption.costHighToLow:
        return 'Cost high to low';
      case SortOption.rating:
        return 'Review';
    }
  }
}

class ProductFilterState {
  final String selectedCategory;
  final String searchQuery;
  final String? selectedBrand;
  final String? selectedStrength;
  final SortOption sortOption;

  const ProductFilterState({
    this.selectedCategory = 'All',
    this.searchQuery = '',
    this.selectedBrand,
    this.selectedStrength,
    this.sortOption = SortOption.popular,
  });

  ProductFilterState copyWith({
    String? selectedCategory,
    String? searchQuery,
    String? selectedBrand,
    String? selectedStrength,
    SortOption? sortOption,
  }) {
    return ProductFilterState(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedBrand: selectedBrand ?? this.selectedBrand,
      selectedStrength: selectedStrength ?? this.selectedStrength,
      sortOption: sortOption ?? this.sortOption,
    );
  }
}

class ProductFilterNotifier extends StateNotifier<ProductFilterState> {
  ProductFilterNotifier() : super(const ProductFilterState());

  void setCategory(String category) {
    state = state.copyWith(selectedCategory: category);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setBrand(String? brand) {
    state = state.copyWith(
      selectedBrand: state.selectedBrand == brand ? null : brand,
    );
  }

  void setStrength(String? strength) {
    state = state.copyWith(
      selectedStrength: state.selectedStrength == strength ? null : strength,
    );
  }

  void setSortOption(SortOption option) {
    state = state.copyWith(sortOption: option);
  }

  void resetFilters() {
    state = const ProductFilterState();
  }
}

final productFilterProvider =
    StateNotifierProvider<ProductFilterNotifier, ProductFilterState>((ref) {
  return ProductFilterNotifier();
});

final allProductsProvider = Provider<List<ProductModel>>((ref) {
  return MockData.products;
});

final filteredProductsProvider = Provider<List<ProductModel>>((ref) {
  final products = ref.watch(allProductsProvider);
  final filter = ref.watch(productFilterProvider);

  var list = products.where((product) {
    // Category match
    if (filter.selectedCategory != 'All' &&
        product.category.toLowerCase() != filter.selectedCategory.toLowerCase()) {
      return false;
    }

    // Search query match
    if (filter.searchQuery.isNotEmpty) {
      final q = filter.searchQuery.toLowerCase();
      final matchName = product.name.toLowerCase().contains(q);
      final matchGeneric = product.genericName.toLowerCase().contains(q);
      final matchBrand = product.brand.toLowerCase().contains(q);
      if (!matchName && !matchGeneric && !matchBrand) {
        return false;
      }
    }

    // Brand filter
    if (filter.selectedBrand != null &&
        product.brand.toLowerCase() != filter.selectedBrand!.toLowerCase()) {
      return false;
    }

    // Strength filter
    if (filter.selectedStrength != null &&
        !product.availableStrengths.contains(filter.selectedStrength)) {
      return false;
    }

    return true;
  }).toList();

  // Sorting
  switch (filter.sortOption) {
    case SortOption.costLowToHigh:
      list.sort((a, b) => a.price.compareTo(b.price));
      break;
    case SortOption.costHighToLow:
      list.sort((a, b) => b.price.compareTo(a.price));
      break;
    case SortOption.rating:
      list.sort((a, b) => b.rating.compareTo(a.rating));
      break;
    case SortOption.popular:
      list.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
      break;
  }

  return list;
});
