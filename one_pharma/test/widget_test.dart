import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_pharma/data/mock/mock_data.dart';
import 'package:one_pharma/main.dart';
import 'package:one_pharma/presentation/screens/home/widgets/hero_banner_carousel.dart';
import 'package:one_pharma/presentation/screens/shell/main_shell_screen.dart';
import 'package:one_pharma/presentation/widgets/medicine_card.dart';

void main() {
  testWidgets('OnePharma app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: OnePharmaApp(),
      ),
    );
    expect(find.byType(OnePharmaApp), findsOneWidget);
    await tester.pumpAndSettle(const Duration(seconds: 3));
  });

  testWidgets('MedicineCard renders wishlist, add to cart, and order now buttons without overflow',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 0.60,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              padding: const EdgeInsets.all(20),
              children: [
                MedicineCard(
                  product: MockData.products.first,
                  isHorizontal: false,
                  onTap: () {},
                ),
                MedicineCard(
                  product: MockData.products[4],
                  isHorizontal: false,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.text('Order Now'), findsNWidgets(2));
    expect(find.byIcon(Icons.add_shopping_cart_rounded), findsNWidgets(2));
    expect(find.byIcon(Icons.favorite_border_rounded), findsNWidgets(2));
    expect(find.byIcon(Icons.favorite_rounded), findsNothing);

    await tester.tap(find.byIcon(Icons.favorite_border_rounded).first);
    await tester.pump();
    expect(find.byIcon(Icons.favorite_rounded), findsOneWidget);
  });

  testWidgets('HeroBannerCarousel renders hero slide and asset images exist',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: HeroBannerCarousel(),
        ),
      ),
    );

    expect(find.text('EXPRESS 30-MIN'), findsOneWidget);
    expect(find.text('Shop Now'), findsOneWidget);

    for (final heroAsset in const [
      'assets/images/hero/hero_delivery.jpg',
      'assets/images/hero/hero_prescription.jpg',
      'assets/images/hero/hero_teleconsult.jpg',
      'assets/images/hero/hero_pharmacy.jpg',
    ]) {
      expect(File(heroAsset).existsSync(), isTrue, reason: 'Missing $heroAsset');
    }
  });

  testWidgets('MainShellScreen bottom nav includes Home, Nearby, center Cart, Wishlist, and Orders',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: MainShellScreen(),
        ),
      ),
    );

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Nearby'), findsOneWidget);
    expect(find.text('Cart'), findsOneWidget);
    expect(find.text('Wishlist'), findsOneWidget);
    expect(find.text('Orders'), findsOneWidget);

    await tester.tap(find.text('Wishlist'));
    await tester.pump();
    expect(find.text('Saved Medicines (0)'), findsOneWidget);
    expect(find.text('No Saved Medicines'), findsOneWidget);

    await tester.tap(find.text('Cart'));
    await tester.pump();
    expect(find.text("You haven't added anything\nto order list"), findsOneWidget);
  });

  test('All mock medical products have valid local studio product images', () {
    expect(MockData.products.length, greaterThanOrEqualTo(12));
    for (final product in MockData.products) {
      final path = product.imageUrl;
      expect(path, isNotNull, reason: '${product.name} should have an imageUrl');
      expect(
        path!.startsWith('assets/images/products/'),
        isTrue,
        reason: '${product.name} should use local bundled studio image',
      );
      expect(
        File(path).existsSync(),
        isTrue,
        reason: 'Asset file missing on disk: $path',
      );
    }
  });
}
