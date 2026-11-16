import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_pharma/core/theme/app_colors.dart';
import 'package:one_pharma/core/theme/app_text_styles.dart';
import 'package:one_pharma/data/mock/mock_data.dart';
import 'package:one_pharma/providers/product_provider.dart';
import 'package:one_pharma/presentation/widgets/primary_button.dart';

class FilterBottomSheet extends ConsumerStatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  ConsumerState<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends ConsumerState<FilterBottomSheet> {
  late String _selectedCategory;
  String? _selectedBrand;
  String? _selectedStrength;
  late SortOption _selectedSort;

  late final List<String> _categories =
      MockData.categories.map((c) => c.name).toList();

  late final List<String> _brands = MockData.products
      .map((p) => p.brand)
      .toSet()
      .toList();

  late final List<String> _strengths = MockData.products
      .expand((p) => p.availableStrengths)
      .toSet()
      .toList();

  @override
  void initState() {
    super.initState();
    final filter = ref.read(productFilterProvider);
    _selectedCategory = filter.selectedCategory;
    _selectedBrand = filter.selectedBrand;
    _selectedStrength = filter.selectedStrength;
    _selectedSort = filter.sortOption;
  }

  void _apply() {
    final notifier = ref.read(productFilterProvider.notifier);
    notifier.setCategory(_selectedCategory);
    notifier.setBrand(_selectedBrand);
    notifier.setStrength(_selectedStrength);
    notifier.setSortOption(_selectedSort);
    Navigator.of(context).pop();
  }

  void _reset() {
    setState(() {
      _selectedCategory = 'All';
      _selectedBrand = null;
      _selectedStrength = null;
      _selectedSort = SortOption.popular;
    });
    ref.read(productFilterProvider.notifier).resetFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 20, 12),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.textPrimary),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Expanded(
                  child: Text(
                    'Filters By',
                    style: AppTextStyles.h3.copyWith(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
                TextButton(
                  onPressed: _reset,
                  child: Text(
                    'Reset',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Scrollable Filter Options
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              children: [
                // Category / Product Type
                Text(
                  'Product Type',
                  style: AppTextStyles.h3.copyWith(fontSize: 15),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  children: _categories
                      .map((cat) {
                    final isSelected = _selectedCategory == cat;
                    return ChoiceChip(
                      label: Text(cat),
                      selected: isSelected,
                      selectedColor: AppColors.primary,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                      backgroundColor: AppColors.scaffoldBackground,
                      shape: StadiumBorder(
                        side: BorderSide(
                          color: isSelected ? AppColors.primary : AppColors.border,
                        ),
                      ),
                      onSelected: (val) {
                        setState(() {
                          _selectedCategory = val ? cat : 'All';
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // Brand
                Text(
                  'Brand',
                  style: AppTextStyles.h3.copyWith(fontSize: 15),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _brands.map((brand) {
                    final isSelected = _selectedBrand == brand;
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedBrand = isSelected ? null : brand;
                        });
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.scaffoldBackground,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color:
                                isSelected ? AppColors.primary : AppColors.border,
                          ),
                        ),
                        child: Text(
                          brand,
                          style: TextStyle(
                            color:
                                isSelected ? Colors.white : AppColors.textPrimary,
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // Mg / Strength
                Text(
                  'Mg',
                  style: AppTextStyles.h3.copyWith(fontSize: 15),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _strengths.map((str) {
                    final isSelected = _selectedStrength == str;
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedStrength = isSelected ? null : str;
                        });
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.scaffoldBackground,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color:
                                isSelected ? AppColors.primary : AppColors.border,
                          ),
                        ),
                        child: Text(
                          str,
                          style: TextStyle(
                            color:
                                isSelected ? Colors.white : AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // Sort Options
                Text(
                  'Sort By',
                  style: AppTextStyles.h3.copyWith(fontSize: 15),
                ),
                const SizedBox(height: 12),
                Column(
                  children: SortOption.values.map((opt) {
                    final isSelected = _selectedSort == opt;
                    return RadioListTile<SortOption>(
                      title: Text(
                        opt.label,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: isSelected ? AppColors.primary : AppColors.textPrimary,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                      value: opt,
                      groupValue: _selectedSort,
                      activeColor: AppColors.primary,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _selectedSort = val);
                        }
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),

          // Apply Filter Button
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
            child: PrimaryButton(
              text: 'APPLY FILTER',
              onPressed: _apply,
            ),
          ),
        ],
      ),
    );
  }
}
