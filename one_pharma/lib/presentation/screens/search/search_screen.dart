import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:one_pharma/core/theme/app_colors.dart';
import 'package:one_pharma/core/theme/app_text_styles.dart';
import 'package:one_pharma/data/mock/mock_data.dart';
import 'package:one_pharma/data/models/product_model.dart';
import 'package:one_pharma/providers/search_history_provider.dart';
import 'package:one_pharma/providers/cart_provider.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<ProductModel> _filterProducts(String query) {
    if (query.trim().isEmpty) return const [];
    final q = query.toLowerCase().trim();
    return MockData.products.where((p) {
      return p.name.toLowerCase().contains(q) ||
          p.genericName.toLowerCase().contains(q) ||
          p.category.toLowerCase().contains(q) ||
          p.description.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final searchHistory = ref.watch(searchHistoryProvider);
    final results = _filterProducts(_query);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
          onPressed: () => context.pop(),
        ),
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.scaffoldBackground,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: Row(
              children: [
                const SizedBox(width: 12),
                const Icon(Icons.search_rounded, color: AppColors.primary, size: 22),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    autofocus: true,
                    style: AppTextStyles.bodyMedium,
                    decoration: InputDecoration(
                      hintText: 'Search medicines, generics, brands...',
                      hintStyle: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textMuted,
                        fontSize: 13,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onChanged: (val) {
                      setState(() => _query = val);
                    },
                    onSubmitted: (val) {
                      if (val.trim().isNotEmpty) {
                        ref.read(searchHistoryProvider.notifier).addQuery(val);
                      }
                    },
                  ),
                ),
                if (_controller.text.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear_rounded, size: 18, color: AppColors.textMuted),
                    onPressed: () {
                      _controller.clear();
                      setState(() => _query = '');
                    },
                  )
                else
                  IconButton(
                    icon: const Icon(Icons.mic_none_rounded, color: AppColors.primary, size: 20),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Listening... Say medicine name (e.g. Betulin Lux)'),
                          duration: Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
      body: _query.isEmpty
          ? _buildDiscoveryView(searchHistory)
          : _buildSearchResults(results),
    );
  }

  Widget _buildDiscoveryView(List<String> history) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      children: [
        if (history.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Searches',
                style: AppTextStyles.h3.copyWith(fontSize: 15),
              ),
              TextButton(
                onPressed: () {
                  ref.read(searchHistoryProvider.notifier).clearAll();
                },
                child: const Text(
                  'Clear All',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: history.map((q) {
              return InputChip(
                label: Text(q, style: const TextStyle(fontSize: 12)),
                backgroundColor: AppColors.scaffoldBackground,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(color: AppColors.borderSubtle),
                ),
                deleteIcon: const Icon(Icons.close_rounded, size: 14),
                onDeleted: () {
                  ref.read(searchHistoryProvider.notifier).removeQuery(q);
                },
                onPressed: () {
                  _controller.text = q;
                  setState(() => _query = q);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
        ],

        Text(
          'Popular Categories',
          style: AppTextStyles.h3.copyWith(fontSize: 15),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: MockData.categories.map((cat) {
            return ActionChip(
              avatar: const Icon(Icons.medication_rounded, size: 16, color: AppColors.primary),
              label: Text(cat.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              backgroundColor: AppColors.primaryLight.withValues(alpha: 0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: AppColors.primary.withValues(alpha: 0.2)),
              ),
              onPressed: () {
                context.push('/category/${cat.name}');
              },
            );
          }).toList(),
        ),

        const SizedBox(height: 28),
        Text(
          'Frequently Ordered',
          style: AppTextStyles.h3.copyWith(fontSize: 15),
        ),
        const SizedBox(height: 12),
        ...MockData.products.take(3).map((p) => _buildProductRow(p)),
      ],
    );
  }

  Widget _buildSearchResults(List<ProductModel> results) {
    if (results.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: AppColors.scaffoldBackground,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.search_off_rounded, size: 40, color: AppColors.textMuted),
              ),
              const SizedBox(height: 16),
              Text(
                'No Medicines Found',
                style: AppTextStyles.h3.copyWith(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                'We couldn\'t find anything matching "$_query". Check your spelling or consult our pharmacist.',
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => context.push('/consult'),
                icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18),
                label: const Text('Ask a Pharmacist'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      itemCount: results.length,
      separatorBuilder: (ctx, i) => const Divider(color: AppColors.divider, height: 16),
      itemBuilder: (context, index) {
        return _buildProductRow(results[index]);
      },
    );
  }

  Widget _buildProductRow(ProductModel product) {
    return InkWell(
      onTap: () {
        ref.read(searchHistoryProvider.notifier).addQuery(product.name);
        context.push('/product/${product.id}');
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.scaffoldBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  (product.imageUrl ?? ''),
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, err, st) => const Icon(
                    Icons.medication_rounded,
                    color: AppColors.primary,
                    size: 28,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          product.name,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (product.isPrescriptionRequired) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEE2E2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Rx',
                            style: TextStyle(
                              color: Color(0xFFDC2626),
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${product.genericName} • ${product.packagingInfo}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textMuted,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    r'$' + product.price.toStringAsFixed(2),
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.shopping_bag_outlined, color: AppColors.primary),
              onPressed: () {
                ref.read(cartProvider.notifier).addItem(product);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${product.name} added to bag'),
                    duration: const Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
