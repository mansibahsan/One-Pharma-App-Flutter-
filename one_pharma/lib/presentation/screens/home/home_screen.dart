import 'package:one_pharma/presentation/widgets/quick_actions_row.dart';
import 'package:one_pharma/presentation/widgets/address_picker_sheet.dart';
import 'package:one_pharma/providers/address_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:one_pharma/core/theme/app_colors.dart';
import 'package:one_pharma/core/theme/app_text_styles.dart';
import 'package:one_pharma/data/mock/mock_data.dart';
import 'package:one_pharma/providers/auth_provider.dart';
import 'package:one_pharma/providers/product_provider.dart';
import 'package:one_pharma/providers/notification_provider.dart';
import 'package:one_pharma/presentation/widgets/section_header.dart';
import 'package:one_pharma/presentation/widgets/medicine_card.dart';
import 'package:one_pharma/presentation/screens/catalog/filter_bottom_sheet.dart';
import 'widgets/category_selector.dart';
import 'widgets/deals_carousel.dart';
import 'widgets/hero_banner_carousel.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    final filter = ref.watch(productFilterProvider);
    final products = ref.watch(filteredProductsProvider);
    final unreadNotifs = ref.watch(unreadNotificationCountProvider);
    final selectedAddress = ref.watch(selectedAddressProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Top App Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Row(
                  children: [
                    // Drawer trigger
                    IconButton(
                      icon: const Icon(Icons.menu_rounded, color: AppColors.primary, size: 28),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                    const SizedBox(width: 4),
                    // Greeting & Location (Interactive)
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => const AddressPickerSheet(),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Deliver to',
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.textMuted,
                                    fontSize: 11,
                                  ),
                                ),
                                const Icon(Icons.keyboard_arrow_down_rounded, size: 14, color: AppColors.textMuted),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  size: 14,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 3),
                                Flexible(
                                  child: Text(
                                    selectedAddress != null
                                        ? '${selectedAddress.label} • ${selectedAddress.area}'
                                        : 'Dhaka 1230, Sector 10',
                                    style: AppTextStyles.h3.copyWith(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Notification Icon with Badge
                    Stack(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.notifications_none_rounded,
                            color: AppColors.primary,
                            size: 26,
                          ),
                          onPressed: () => context.push('/notifications'),
                        ),
                        if (unreadNotifs > 0)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '$unreadNotifs',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    // User Avatar
                    GestureDetector(
                      onTap: () => context.push('/profile'),
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: AppColors.primaryLight,
                        child: Text(
                          (user?.name.isNotEmpty == true)
                              ? user!.name[0].toUpperCase()
                              : 'H',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Search Bar with Filter Icon
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.scaffoldBackground,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      const Icon(Icons.search_rounded, color: AppColors.textMuted, size: 22),
                      const SizedBox(width: 10),
                      Expanded(
                        child: InkWell(
                          onTap: () => context.push('/search'),
                          child: IgnorePointer(
                            child: TextField(
                              controller: _searchController,
                              style: AppTextStyles.bodyMedium,
                              decoration: InputDecoration(
                                hintText: 'Search medicine, health products...',
                                hintStyle: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textMuted,
                                  fontSize: 13,
                                ),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (_searchController.text.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.clear, size: 18, color: AppColors.textMuted),
                          onPressed: () {
                            _searchController.clear();
                            ref
                                .read(productFilterProvider.notifier)
                                .setSearchQuery('');
                          },
                        ),
                      Container(
                        margin: const EdgeInsets.only(right: 6),
                        child: IconButton(
                          icon: const Icon(
                            Icons.tune_rounded,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => const FilterBottomSheet(),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Hero Banner Carousel (Real Photography)
            const SliverToBoxAdapter(
              child: HeroBannerCarousel(),
            ),

            // Quick Healthcare Actions
            const SliverToBoxAdapter(
              child: QuickActionsRow(),
            ),

            // Shop By Category
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionHeader(
                      title: 'Shop By Category',
                      actionLabel: 'See All',
                      onAction: () => context.push('/category/All'),
                    ),
                    const SizedBox(height: 8),
                    CategorySelector(
                      selectedCategory: filter.selectedCategory,
                      onCategorySelected: (cat) {
                        ref
                            .read(productFilterProvider.notifier)
                            .setCategory(cat);
                        if (cat != 'All') {
                          context.push('/category/${Uri.encodeComponent(cat)}');
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Deals & Offers Carousel
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionHeader(
                      title: 'Deals & Offers',
                      actionLabel: 'See All',
                      onAction: () => context.push('/category/All'),
                    ),
                    const SizedBox(height: 10),
                    DealsCarousel(
                      onDealTap: (prodId) {
                        context.push('/product/$prodId');
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Partner Pharmacies Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionHeader(
                      title: 'Nearby Pharmacies',
                      actionLabel: 'See Map',
                      onAction: () => context.go('/map'),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 72,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        clipBehavior: Clip.none,
                        itemCount: MockData.nearbyPharmacies.length,
                        itemBuilder: (context, index) {
                          final pharm = MockData.nearbyPharmacies[index];
                          return GestureDetector(
                            onTap: () => context.go('/map'),
                            child: Container(
                              width: 140,
                              margin: const EdgeInsets.only(right: 12),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.scaffoldBackground,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: AppColors.borderSubtle),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.local_pharmacy_rounded,
                                      color: AppColors.primary,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          pharm.name,
                                          style: AppTextStyles.h3.copyWith(fontSize: 12),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.star_rounded,
                                              size: 12,
                                              color: AppColors.primary,
                                            ),
                                            Text(
                                              ' ${pharm.rating}',
                                              style: AppTextStyles.caption.copyWith(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Products Grid Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                child: SectionHeader(
                  title: 'All Medicines',
                  actionLabel: 'See All',
                  onAction: () => context.push('/category/All'),
                ),
              ),
            ),

            // Products 2-column Grid
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.60,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final product = products[index % products.length];
                    return MedicineCard(
                      product: product,
                      isHorizontal: false,
                      onTap: () {
                        context.push('/product/${product.id}');
                      },
                    );
                  },
                  childCount: products.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
