import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:one_pharma/core/theme/app_colors.dart';
import 'package:one_pharma/core/theme/app_text_styles.dart';
import 'package:one_pharma/providers/product_provider.dart';
import 'package:one_pharma/presentation/widgets/medicine_card.dart';
import 'package:one_pharma/presentation/screens/catalog/filter_bottom_sheet.dart';

class CategoryProductsScreen extends ConsumerStatefulWidget {
  final String categoryName;

  const CategoryProductsScreen({
    super.key,
    required this.categoryName,
  });

  @override
  ConsumerState<CategoryProductsScreen> createState() =>
      _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends ConsumerState<CategoryProductsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(productFilterProvider.notifier).setCategory(widget.categoryName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(filteredProductsProvider);
    final activeCategory = ref.watch(productFilterProvider).selectedCategory;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () {
            ref.read(productFilterProvider.notifier).setCategory('All');
            context.pop();
          },
        ),
        title: Text(
          activeCategory == 'All' ? 'All Medical Items' : activeCategory,
          style: AppTextStyles.h3.copyWith(fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded, color: AppColors.textPrimary),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const FilterBottomSheet(),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined, color: AppColors.textPrimary),
            onPressed: () => context.push('/cart'),
          ),
        ],
      ),
      body: SafeArea(
        child: products.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.medication_outlined,
                      size: 64,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No products found',
                      style: AppTextStyles.h3,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Try resetting your filters or search term',
                      style: AppTextStyles.bodySmall,
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        ref.read(productFilterProvider.notifier).resetFilters();
                      },
                      child: const Text('Reset Filters'),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return MedicineCard(
                    product: product,
                    isHorizontal: true,
                    onTap: () {
                      context.push('/product/${product.id}');
                    },
                  );
                },
              ),
      ),
    );
  }
}
