import 'package:flutter/material.dart';
import '../models/address_model.dart';
import '../models/prescription_model.dart';
import '../models/reminder_model.dart';
import '../models/pharmacist_model.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';
import '../models/cart_item_model.dart';
import '../models/order_model.dart';
import '../models/pharmacy_model.dart';
import '../models/user_model.dart';
import '../models/notification_model.dart';
import '../models/chat_message_model.dart';

class MockData {
  MockData._();

  static const UserModel currentUser = UserModel(
    id: 'user_1',
    name: 'Hera Rahman',
    email: 'hera.rahman@onepharma.com',
    phone: '+880 1711-896356',
    address: 'House #28, Road #30, Sector #10\nUttara, Dhaka-1230',
    role: 'Verified Patient • Dhaka, BD',
    userRole: UserRole.patient,
  );

  static const UserModel currentDoctor = UserModel(
    id: 'doc_1',
    name: 'Dr. Tanjila Ahmed, PharmD',
    email: 'dr.tanjila@onepharma.com',
    phone: '+880 1711-554433',
    address: 'Evercare Hospital, Bashundhara R/A, Dhaka',
    role: 'Clinical Pharmacist Specialist • BMDC Verified',
    userRole: UserRole.doctor,
    specialty: 'Clinical Pharmacist & Diabetes Care',
    licenseNumber: 'REG-DH-849204',
    hospital: 'Evercare Hospital Dhaka',
    avatarUrl: 'assets/images/hero/hero_teleconsult.jpg',
  );

  static const List<CategoryModel> categories = [
    CategoryModel(
      id: 'cat_all',
      name: 'All',
      icon: Icons.grid_view_rounded,
      itemCount: 12,
      tintColor: Color(0xFFFF4858),
    ),
    CategoryModel(
      id: 'cat_tablets',
      name: 'Tablets',
      icon: Icons.medication_rounded,
      itemCount: 2,
      tintColor: Color(0xFF2E90FA),
    ),
    CategoryModel(
      id: 'cat_syrups',
      name: 'Syrups',
      icon: Icons.medication_liquid_rounded,
      itemCount: 2,
      tintColor: Color(0xFFF79009),
    ),
    CategoryModel(
      id: 'cat_injections',
      name: 'Injections',
      icon: Icons.vaccines_rounded,
      itemCount: 1,
      tintColor: Color(0xFF7A5AF8),
    ),
    CategoryModel(
      id: 'cat_saline',
      name: 'Saline & IV',
      icon: Icons.water_drop_rounded,
      itemCount: 2,
      tintColor: Color(0xFF0EA5E9),
    ),
    CategoryModel(
      id: 'cat_antiseptic',
      name: 'Antiseptic',
      icon: Icons.sanitizer_rounded,
      itemCount: 1,
      tintColor: Color(0xFF0D9488),
    ),
    CategoryModel(
      id: 'cat_ppe',
      name: 'Safety & PPE',
      icon: Icons.masks_rounded,
      itemCount: 2,
      tintColor: Color(0xFF12B76A),
    ),
    CategoryModel(
      id: 'cat_diabetes',
      name: 'Diabetes',
      icon: Icons.bloodtype_rounded,
      itemCount: 1,
      tintColor: Color(0xFF2563EB),
    ),
    CategoryModel(
      id: 'cat_vitamins',
      name: 'Vitamins',
      icon: Icons.wb_sunny_rounded,
      itemCount: 1,
      tintColor: Color(0xFFEE46BC),
    ),
  ];

  static const List<ProductModel> products = [
    ProductModel(
      id: 'prod_napa_extend',
      name: 'Napa Extend',
      genericName: 'Paracetamol Prolonged-Release',
      brand: 'Beximco Pharma',
      category: 'Tablets',
      selectedStrength: '665mg',
      availableStrengths: ['500mg', '665mg'],
      price: 4.50,
      originalPrice: 6.00,
      discountPercent: 25,
      rating: 4.9,
      reviewCount: 342,
      isPrescriptionRequired: false,
      description:
          'Extended-release Paracetamol analgesic and antipyretic formulated for sustained 8-hour relief from fever, headache, muscle ache, and joint pain.',
      indications:
          '• Adults & children 12+: 1–2 tablets every 8 hours.\n• Do not exceed 6 tablets in 24 hours.\n• Swallow whole with water; do not crush.',
      precautions:
          'Avoid concurrent use with other paracetamol-containing products. Consult a doctor if liver impairment is present.',
      packagingInfo: 'Box of 20 tablets (2x10 blister)',
      iconIndex: 0,
      imageUrl: 'assets/images/products/paracetamol_tablets.jpg',
      images: [
        'assets/images/products/paracetamol_tablets.jpg',
      ],
    ),
    ProductModel(
      id: 'prod_cough_syrup',
      name: 'Tusca Plus Syrup',
      genericName: 'Dextromethorphan & Guaifenesin',
      brand: 'Square Pharma',
      category: 'Syrups',
      selectedStrength: '120ml',
      availableStrengths: ['100ml', '120ml', '200ml'],
      price: 7.20,
      originalPrice: 9.00,
      discountPercent: 20,
      rating: 4.8,
      reviewCount: 194,
      isPrescriptionRequired: false,
      description:
          'Dual-action cough suppressant and expectorant syrup that calms dry, irritating coughs while loosening stubborn chest mucus.',
      indications:
          '• Shake well before each use.\n• Adults: 10ml every 6–8 hours using the dosing cup.\n• Drink warm water afterwards.',
      precautions: 'May cause mild drowsiness. Store below 25°C away from direct sunlight.',
      packagingInfo: '120ml Amber Bottle + Dosing Cup',
      iconIndex: 1,
      imageUrl: 'assets/images/products/cough_syrup.jpg',
      images: [
        'assets/images/products/cough_syrup.jpg',
      ],
    ),
    ProductModel(
      id: 'prod_ceftriaxone_inj',
      name: 'Ceftriaxone IV/IM',
      genericName: 'Ceftriaxone Sodium Sterile Powder',
      brand: 'Incepta Pharma',
      category: 'Injections',
      selectedStrength: '1g Vial',
      availableStrengths: ['500mg', '1g Vial', '2g Vial'],
      price: 14.50,
      originalPrice: 18.00,
      discountPercent: 19,
      rating: 4.9,
      reviewCount: 112,
      isPrescriptionRequired: true,
      description:
          'Third-generation broad-spectrum cephalosporin antibiotic injection indicated for severe respiratory, urinary, and systemic bacterial infections.',
      indications:
          '• Administered intravenously or intramuscularly by a qualified healthcare professional.\n• Reconstitute with sterile water for injection prior to use.',
      precautions:
          'Prescription mandatory. Screen for cephalosporin or penicillin hypersensitivity before administration.',
      packagingInfo: '1g Sterile Vial + 10ml WFI + Syringe',
      iconIndex: 2,
      imageUrl: 'assets/images/products/injection_vial.jpg',
      images: [
        'assets/images/products/injection_vial.jpg',
      ],
    ),
    ProductModel(
      id: 'prod_normal_saline',
      name: 'Normal Saline 0.9%',
      genericName: 'Sodium Chloride IV Infusion USP',
      brand: 'Opso Saline',
      category: 'Saline & IV',
      selectedStrength: '500ml',
      availableStrengths: ['250ml', '500ml', '1000ml'],
      price: 5.80,
      originalPrice: 7.00,
      discountPercent: 17,
      rating: 5.0,
      reviewCount: 265,
      isPrescriptionRequired: true,
      description:
          'Sterile, non-pyrogenic isotonic 0.9% Sodium Chloride intravenous solution for fluid resuscitation, electrolyte replacement, and IV drug dilution.',
      indications:
          '• For intravenous infusion or wound irrigation under clinical supervision.\n• Inspect bag clarity before administration.',
      precautions:
          'Single-dose sterile container. Do not use if solution is cloudy or seal is compromised.',
      packagingInfo: '500ml Sterile IV Infusion Bag',
      iconIndex: 3,
      imageUrl: 'assets/images/products/iv_saline_bag.jpg',
      images: [
        'assets/images/products/iv_saline_bag.jpg',
      ],
    ),
    ProductModel(
      id: 'prod_hexisol_rub',
      name: 'Hexisol Hand Rub',
      genericName: 'Chlorhexidine Gluconate 0.5% + Alcohol 70%',
      brand: 'ACI Pharma',
      category: 'Antiseptic',
      selectedStrength: '500ml',
      availableStrengths: ['250ml', '500ml'],
      price: 9.50,
      originalPrice: 12.50,
      discountPercent: 24,
      rating: 5.0,
      reviewCount: 418,
      isPrescriptionRequired: false,
      description:
          'Hospital-grade surgical antiseptic hand rub providing rapid bactericidal, virucidal, and fungicidal protection killing 99.99% of germs without water.',
      indications:
          '• Apply 3–5ml onto dry palms and rub thoroughly across hands and wrists for 30 seconds.\n• Allow to air dry completely.',
      precautions:
          'Flammable liquid; keep away from heat or open flame. For external use only.',
      packagingInfo: '500ml Pump Dispenser Bottle',
      iconIndex: 4,
      imageUrl: 'assets/images/products/hexisol_antiseptic.jpg',
      images: [
        'assets/images/products/hexisol_antiseptic.jpg',
      ],
    ),
    ProductModel(
      id: 'prod_surgical_mask',
      name: '3-Ply Surgical Mask',
      genericName: 'Meltblown Medical Face Mask',
      brand: 'MedShield Care',
      category: 'Safety & PPE',
      selectedStrength: '50 Pcs',
      availableStrengths: ['20 Pcs', '50 Pcs', '100 Pcs'],
      price: 8.00,
      originalPrice: 12.00,
      discountPercent: 33,
      rating: 4.9,
      reviewCount: 530,
      isPrescriptionRequired: false,
      description:
          'Breathable 3-layer medical-grade disposable face masks with ≥98% BFE meltblown filter, soft elastic ear loops, and adjustable nose bridge.',
      indications:
          '• Pinch nose strip securely over bridge and cover nose and chin completely.\n• Replace every 4 hours or if damp.',
      precautions: 'Single-use disposable medical barrier. Do not wash or reuse.',
      packagingInfo: 'Dispenser Box of 50 Masks',
      iconIndex: 0,
      imageUrl: 'assets/images/products/surgical_mask.jpg',
      images: [
        'assets/images/products/surgical_mask.jpg',
      ],
    ),
    ProductModel(
      id: 'prod_nitrile_gloves',
      name: 'ProGuard Nitrile Gloves',
      genericName: 'Powder-Free Examination Gloves',
      brand: 'MedShield Care',
      category: 'Safety & PPE',
      selectedStrength: 'Size L (100)',
      availableStrengths: ['Size M (100)', 'Size L (100)'],
      price: 13.50,
      originalPrice: 18.00,
      discountPercent: 25,
      rating: 4.9,
      reviewCount: 289,
      isPrescriptionRequired: false,
      description:
          'Latex-free, powder-free textured blue nitrile medical examination gloves offering superior puncture resistance and tactile sensitivity.',
      indications:
          '• Suitable for clinical examinations, wound dressing, lab handling, and home care.\n• Ambidextrous beaded cuff fit.',
      precautions: 'Single use only. Store in a cool, dry place away from ozone sources.',
      packagingInfo: 'Box of 100 Exam Gloves',
      iconIndex: 1,
      imageUrl: 'assets/images/products/nitrile_gloves.jpg',
      images: [
        'assets/images/products/nitrile_gloves.jpg',
      ],
    ),
    ProductModel(
      id: 'prod_zimax_500',
      name: 'Zimax 500mg',
      genericName: 'Azithromycin Dihydrate USP',
      brand: 'Square Pharma',
      category: 'Tablets',
      selectedStrength: '500mg',
      availableStrengths: ['250mg', '500mg'],
      price: 11.00,
      originalPrice: 14.00,
      discountPercent: 21,
      rating: 4.8,
      reviewCount: 156,
      isPrescriptionRequired: true,
      description:
          'Macrolide antibiotic tablet indicated for community-acquired respiratory infections, acute bacterial sinusitis, tonsillitis, and skin infections.',
      indications:
          '• Strictly as prescribed by a registered physician.\n• Complete the full prescribed antibiotic course.',
      precautions:
          'Prescription required. Inform your doctor of any macrolide allergy or heart rhythm history.',
      packagingInfo: 'Box of 6 Film-Coated Tablets',
      iconIndex: 2,
      imageUrl: 'assets/images/products/antibiotic_tablets.jpg',
      images: [
        'assets/images/products/antibiotic_tablets.jpg',
      ],
    ),
    ProductModel(
      id: 'prod_insulin_pen',
      name: 'Lantus SoloStar Pen',
      genericName: 'Insulin Glargine 100 Units/ml',
      brand: 'Sanofi Diabetes',
      category: 'Diabetes',
      selectedStrength: '100U/ml',
      availableStrengths: ['100U/ml (1 Pen)', '100U/ml (3 Pens)'],
      price: 34.00,
      originalPrice: 42.00,
      discountPercent: 19,
      rating: 5.0,
      reviewCount: 178,
      isPrescriptionRequired: true,
      description:
          'Long-acting basal insulin analog pre-filled injection pen providing steady 24-hour glycemic control for Type 1 and Type 2 diabetes.',
      indications:
          '• Administer subcutaneously once daily at the same time each day.\n• Rotate injection sites (abdomen, thigh, upper arm).',
      precautions:
          'Prescription required. Refrigerate unopened pens at 2°C–8°C. Do not freeze.',
      packagingInfo: '1 Pre-filled 3ml Pen (Cold-Chain)',
      iconIndex: 3,
      imageUrl: 'assets/images/products/insulin_pen.jpg',
      images: [
        'assets/images/products/insulin_pen.jpg',
      ],
    ),
    ProductModel(
      id: 'prod_antacid_syrup',
      name: 'Gaviscon Mint Syrup',
      genericName: 'Sodium Alginate & Bicarbonate',
      brand: 'Reckitt Health',
      category: 'Syrups',
      selectedStrength: '200ml',
      availableStrengths: ['150ml', '200ml'],
      price: 8.50,
      originalPrice: 10.50,
      discountPercent: 19,
      rating: 4.8,
      reviewCount: 224,
      isPrescriptionRequired: false,
      description:
          'Soothing peppermint oral suspension that forms a protective raft over stomach contents for rapid relief from heartburn, acid reflux, and indigestion.',
      indications:
          '• Shake well before use.\n• Take 10–20ml after meals and at bedtime.',
      precautions: 'Consult physician if on a low-sodium restricted diet.',
      packagingInfo: '200ml Mint Suspension Bottle',
      iconIndex: 4,
      imageUrl: 'assets/images/products/antacid_syrup.jpg',
      images: [
        'assets/images/products/antacid_syrup.jpg',
      ],
    ),
    ProductModel(
      id: 'prod_ors_saline',
      name: 'Orsaline-N (ORS)',
      genericName: 'WHO Oral Rehydration Salts',
      brand: 'SMC Enterprise',
      category: 'Saline & IV',
      selectedStrength: '20 Sachets',
      availableStrengths: ['10 Sachets', '20 Sachets'],
      price: 4.00,
      originalPrice: 5.00,
      discountPercent: 20,
      rating: 5.0,
      reviewCount: 410,
      isPrescriptionRequired: false,
      description:
          'WHO-recommended low-osmolarity oral rehydration salts rapidly restoring fluids, sodium, potassium, and zinc-balanced electrolytes during dehydration.',
      indications:
          '• Dissolve 1 full sachet in 500ml clean drinking water.\n• Consume within 24 hours of preparation.',
      precautions: 'Do not boil the solution after mixing. Seek medical care if symptoms persist.',
      packagingInfo: 'Box of 20 Foil Sachets',
      iconIndex: 0,
      imageUrl: 'assets/images/products/ors_saline.jpg',
      images: [
        'assets/images/products/ors_saline.jpg',
      ],
    ),
    ProductModel(
      id: 'prod_centrum_multi',
      name: 'Daily Multivitamin',
      genericName: 'Vitamin C, D3, Zinc & B-Complex',
      brand: 'Haleon Wellness',
      category: 'Vitamins',
      selectedStrength: '60 Softgels',
      availableStrengths: ['30 Softgels', '60 Softgels'],
      price: 18.00,
      originalPrice: 24.00,
      discountPercent: 25,
      rating: 4.9,
      reviewCount: 315,
      isPrescriptionRequired: false,
      description:
          'Complete daily micronutrient blend fortified with Vitamin C, D3, Zinc, and B-Complex to reinforce immune defense, cellular energy, and recovery.',
      indications:
          '• Take 1 softgel daily with breakfast.\n• Swallow with a full glass of water.',
      precautions: 'Do not exceed recommended daily intake.',
      packagingInfo: 'Bottle of 60 Softgels',
      iconIndex: 1,
      imageUrl: 'assets/images/products/multivitamin_bottle.jpg',
      images: [
        'assets/images/products/multivitamin_bottle.jpg',
      ],
    ),
  ];

  static List<CartItemModel> get initialCartItems => [
    CartItemModel(
      product: products[0], // Napa Extend
      quantity: 1,
      strength: '665mg',
      isSelected: true,
    ),
    CartItemModel(
      product: products[4], // Hexisol Hand Rub
      quantity: 1,
      strength: '500ml',
      isSelected: true,
    ),
    CartItemModel(
      product: products[5], // 3-Ply Surgical Mask
      quantity: 1,
      strength: '50 Pcs',
      isSelected: true,
    ),
    CartItemModel(
      product: products[6], // Nitrile Gloves
      quantity: 1,
      strength: 'Size L (100)',
      isSelected: false,
    ),
  ];

  static const List<PharmacyModel> nearbyPharmacies = [
    PharmacyModel(
      id: 'pharm_1',
      name: 'Lazz Pharma',
      address: 'House 12, Road 4, Sector 7, Uttara, Dhaka',
      rating: 5.0,
      reviewCount: 340,
      distanceKm: 0.8,
      isOpen: true,
      openingHours: 'Open 24/7',
      phone: '+880 1711-234567',
      latitudeOffset: -0.003,
      longitudeOffset: -0.002,
    ),
    PharmacyModel(
      id: 'pharm_2',
      name: 'Smart Pharma',
      address: 'Plot 45, Sector 10, Uttara, Dhaka',
      rating: 5.0,
      reviewCount: 280,
      distanceKm: 1.2,
      isOpen: true,
      openingHours: '8:00 AM - 11:30 PM',
      phone: '+880 1822-345678',
      latitudeOffset: 0.002,
      longitudeOffset: 0.004,
    ),
    PharmacyModel(
      id: 'pharm_3',
      name: 'Central Pharmacy',
      address: 'Sonargaon Janapath, Sector 9, Dhaka',
      rating: 4.8,
      reviewCount: 195,
      distanceKm: 1.7,
      isOpen: true,
      openingHours: '9:00 AM - 11:00 PM',
      phone: '+880 1933-456789',
      latitudeOffset: 0.005,
      longitudeOffset: -0.003,
    ),
    PharmacyModel(
      id: 'pharm_4',
      name: 'Care Meds',
      address: 'Rabindra Sarani, Sector 3, Dhaka',
      rating: 4.9,
      reviewCount: 412,
      distanceKm: 2.3,
      isOpen: false,
      openingHours: 'Opens at 8:00 AM',
      phone: '+880 1544-567890',
      latitudeOffset: -0.006,
      longitudeOffset: 0.005,
    ),
  ];

  static List<OrderModel> get mockOrders => [
    OrderModel(
      id: 'ord_1',
      orderNumber: 'OP-2026-98231',
      orderDate: DateTime.now().subtract(const Duration(hours: 4)),
      status: OrderStatus.shipped,
      items: [
        CartItemModel(product: products[7], quantity: 1, strength: '500mg'),
        CartItemModel(product: products[1], quantity: 1, strength: '120ml'),
      ],
      subtotal: 18.20,
      deliveryFee: 3.00,
      discount: 2.00,
      total: 19.20,
      deliveryAddress: currentUser.address,
      contactNumber: currentUser.phone,
      paymentMethod: 'Mastercard (**** 4563)',
      prescriptionUrl: 'uploaded_prescription.jpg',
      trackingTimeline: const [
        TrackingStep(
          title: 'Shipped',
          date: '16 Nov',
          time: '04:30 pm',
          description: 'Order picked up and on route with cold-chain rider',
          isCompleted: true,
          isCurrent: true,
        ),
        TrackingStep(
          title: 'Picked',
          date: '16 Nov',
          time: '03:50 pm',
          description: 'Pharmacy packed items and assigned courier',
          isCompleted: true,
        ),
        TrackingStep(
          title: 'Processed',
          date: '16 Nov',
          time: '03:20 pm',
          description: 'Prescription verified by licensed pharmacist',
          isCompleted: true,
        ),
        TrackingStep(
          title: 'Confirming',
          date: '16 Nov',
          time: '02:45 pm',
          description: 'Order confirmed and inventory reserved',
          isCompleted: true,
        ),
        TrackingStep(
          title: 'Pending',
          date: '16 Nov',
          time: '02:30 pm',
          description: 'Payment authorized via Mastercard gateway',
          isCompleted: true,
        ),
      ],
    ),
    OrderModel(
      id: 'ord_2',
      orderNumber: 'OP-2026-88412',
      orderDate: DateTime.now().subtract(const Duration(days: 2)),
      status: OrderStatus.confirming,
      items: [
        CartItemModel(product: products[8], quantity: 1, strength: '100U/ml'),
      ],
      subtotal: 34.00,
      deliveryFee: 3.00,
      discount: 0.00,
      total: 37.00,
      deliveryAddress: currentUser.address,
      contactNumber: currentUser.phone,
      paymentMethod: 'Cash on Delivery',
      trackingTimeline: const [
        TrackingStep(
          title: 'Confirming',
          date: '14 Nov',
          time: '11:15 am',
          description: 'Order awaiting cold-chain stock verification',
          isCompleted: true,
          isCurrent: true,
        ),
        TrackingStep(
          title: 'Pending',
          date: '14 Nov',
          time: '10:50 am',
          description: 'Order received into the system',
          isCompleted: true,
        ),
      ],
    ),
    OrderModel(
      id: 'ord_3',
      orderNumber: 'OP-2026-76129',
      orderDate: DateTime.now().subtract(const Duration(days: 10)),
      status: OrderStatus.delivered,
      items: [
        CartItemModel(product: products[4], quantity: 2, strength: '500ml'),
        CartItemModel(product: products[5], quantity: 1, strength: '50 Pcs'),
      ],
      subtotal: 27.00,
      deliveryFee: 3.00,
      discount: 5.00,
      total: 25.00,
      deliveryAddress: currentUser.address,
      contactNumber: currentUser.phone,
      paymentMethod: 'bKash / Nagad',
      trackingTimeline: const [
        TrackingStep(
          title: 'Delivered',
          date: '06 Nov',
          time: '02:40 pm',
          description: 'Delivered to recipient with digital signature',
          isCompleted: true,
          isCurrent: true,
        ),
      ],
    ),
  ];

  static const List<NotificationModel> notifications = [
    NotificationModel(
      id: 'notif_1',
      title: 'PPE & Antiseptic 25% Off',
      message:
          'Save up to 25% on Hexisol Hand Rub, 3-Ply Surgical Masks, and Nitrile Gloves.',
      time: '10:14 AM',
      group: NotificationGroup.today,
      isRead: false,
    ),
    NotificationModel(
      id: 'notif_2',
      title: 'Cold-Chain Insulin Ready',
      message:
          'Your Lantus SoloStar Insulin prescription refill is verified and eligible for express cold delivery.',
      time: '08:30 AM',
      group: NotificationGroup.today,
      isRead: false,
    ),
    NotificationModel(
      id: 'notif_3',
      title: 'Free Express Delivery',
      message:
          'Enjoy zero delivery fee on all pharmacy orders above \$25 this weekend.',
      time: '03:18 PM',
      group: NotificationGroup.yesterday,
      isRead: true,
    ),
    NotificationModel(
      id: 'notif_4',
      title: '2x Loyalty Health Points',
      message:
          'Earn double pharmacy reward stars on Daily Multivitamin & Orsaline-N wellness packs.',
      time: '04:14 PM',
      group: NotificationGroup.yesterday,
      isRead: true,
    ),
    NotificationModel(
      id: 'notif_5',
      title: '24/7 Pharmacist Support Live',
      message:
          'Have questions about dosage or IV saline care? Start an instant chat with our clinical pharmacists.',
      time: '06:20 PM',
      group: NotificationGroup.lastWeek,
      isRead: true,
    ),
  ];

  static const List<ChatMessageModel> chatMessages = [
    ChatMessageModel(
      id: 'msg_1',
      text: 'Hello! Welcome to 1 Pharma Support. How can we assist you today?',
      isUser: false,
      time: '10:00 AM',
    ),
    ChatMessageModel(
      id: 'msg_2',
      text: 'Hi, where can I track my active order?',
      isUser: true,
      time: '10:02 AM',
    ),
    ChatMessageModel(
      id: 'msg_3',
      text:
          'You can track delivery in real-time under the "Orders" section from the bottom navigation.',
      isUser: false,
      time: '10:03 AM',
    ),
  ];

  static List<AddressModel> get initialAddresses => [
    const AddressModel(
      id: 'addr_home',
      label: 'Home',
      recipientName: 'Hera Rahman',
      phone: '+880 1711-896356',
      streetAddress: 'House #28, Road #30, Sector #10',
      area: 'Uttara',
      city: 'Dhaka 1230',
      isDefault: true,
    ),
    const AddressModel(
      id: 'addr_office',
      label: 'Office',
      recipientName: 'Hera Rahman',
      phone: '+880 1714-567890',
      streetAddress: 'Level 8, Concord Tower, Gulshan-2',
      area: 'Gulshan',
      city: 'Dhaka 1212',
      isDefault: false,
    ),
    const AddressModel(
      id: 'addr_parents',
      label: 'Parents',
      recipientName: 'Rafiqul Rahman',
      phone: '+880 1819-876543',
      streetAddress: 'Flat 4B, Green Road, Dhanmondi',
      area: 'Dhanmondi',
      city: 'Dhaka 1205',
      isDefault: false,
    ),
  ];

  static List<ProductModel> get initialWishlist => [
    products[4], // Hexisol Hand Rub
    products[11], // Daily Multivitamin
    products[5], // Surgical Mask
  ];

  static List<PrescriptionModel> get initialPrescriptions => [
    PrescriptionModel(
      id: 'rx_pending_1',
      title: 'Uploaded Slip • Fever & Cough',
      patientName: 'Hera Rahman',
      doctorName: 'Pending Doctor Audit',
      doctorSpecialty: 'Awaiting Clinical Verification',
      hospital: 'Patient Uploaded Slip',
      issueDate: DateTime.now().subtract(const Duration(hours: 2)),
      expiryDate: DateTime.now().add(const Duration(days: 30)),
      status: PrescriptionStatus.pending,
      fileUrl: 'assets/images/products/paracetamol_tablets.jpg',
      linkedMedicines: [
        products[0], // Napa Extend
        products[1], // Tusca Plus Cough Syrup
      ],
      notes: 'Patient requested verification for 5-day fever and dry cough regimen.',
    ),
    PrescriptionModel(
      id: 'rx_1',
      title: 'Chest & Respiratory Care',
      patientName: 'Hera Rahman',
      doctorName: 'Dr. Shahriar Kabir, MD',
      doctorSpecialty: 'Pulmonologist & Chest Specialist',
      hospital: 'Evercare Hospital Dhaka',
      issueDate: DateTime.now().subtract(const Duration(days: 12)),
      expiryDate: DateTime.now().add(const Duration(days: 48)),
      status: PrescriptionStatus.verified,
      fileUrl: 'assets/images/products/antibiotic_tablets.jpg',
      linkedMedicines: [
        products[7], // Zimax 500mg
        products[1], // Tusca Plus Cough Syrup
        products[2], // Ceftriaxone IV/IM
      ],
      notes: 'Take Zimax 500mg once daily after breakfast. Complete full course.',
    ),
    PrescriptionModel(
      id: 'rx_2',
      title: 'Diabetes & Fluid Support',
      doctorName: 'Dr. Nusrat Jahan, MBBS, FCPS',
      doctorSpecialty: 'Endocrinology & Internal Medicine',
      hospital: 'Square Hospital',
      issueDate: DateTime.now().subtract(const Duration(days: 28)),
      expiryDate: DateTime.now().add(const Duration(days: 62)),
      status: PrescriptionStatus.verified,
      fileUrl: 'assets/images/products/insulin_pen.jpg',
      linkedMedicines: [
        products[8], // Lantus Insulin Pen
        products[3], // Normal Saline 0.9%
      ],
      notes: 'Monitor fasting blood glucose daily. Store insulin at 2–8°C.',
    ),
    PrescriptionModel(
      id: 'rx_3',
      title: 'Acute Fever & Gastric Relief',
      doctorName: 'Dr. Anisur Rahman, MD',
      doctorSpecialty: 'General Medicine',
      hospital: 'United Hospital',
      issueDate: DateTime.now().subtract(const Duration(days: 95)),
      expiryDate: DateTime.now().subtract(const Duration(days: 5)),
      status: PrescriptionStatus.expired,
      fileUrl: 'assets/images/products/paracetamol_tablets.jpg',
      linkedMedicines: [
        products[0], // Napa Extend
        products[9], // Gaviscon Mint Syrup
      ],
      notes: 'Expired course. Consultation renewal required before refilling.',
    ),
  ];

  static List<ReminderModel> get initialReminders => [
    ReminderModel(
      id: 'rem_1',
      product: products[11], // Daily Multivitamin
      dosage: '1 Softgel',
      instruction: 'After breakfast',
      slot: ReminderTimeSlot.morning,
      time: '08:30 AM',
      isTakenToday: true,
      remainingDoses: 4, // Due for refill!
      totalDoses: 30,
    ),
    ReminderModel(
      id: 'rem_2',
      product: products[0], // Napa Extend
      dosage: '1 Tablet',
      instruction: 'After lunch',
      slot: ReminderTimeSlot.afternoon,
      time: '01:15 PM',
      isTakenToday: false,
      remainingDoses: 18,
      totalDoses: 20,
    ),
    ReminderModel(
      id: 'rem_3',
      product: products[7], // Zimax 500mg
      dosage: '1 Tablet (Rx)',
      instruction: 'With evening meal',
      slot: ReminderTimeSlot.evening,
      time: '06:30 PM',
      isTakenToday: false,
      remainingDoses: 2, // Due for refill!
      totalDoses: 6,
    ),
    ReminderModel(
      id: 'rem_4',
      product: products[8], // Lantus Insulin Pen
      dosage: '12 Units SC (Rx)',
      instruction: 'Before bedtime',
      slot: ReminderTimeSlot.night,
      time: '10:00 PM',
      isTakenToday: false,
      remainingDoses: 22,
      totalDoses: 30,
    ),
  ];

  static List<PharmacistModel> get pharmacists => [
    const PharmacistModel(
      id: 'pharm_1',
      name: 'Dr. Tanjila Ahmed, PharmD',
      qualification: 'PharmD (DU), BCPS (USA)',
      designation: 'Clinical Pharmacist Specialist',
      rating: 4.9,
      reviewCount: 142,
      experienceYears: 8,
      consultationFee: 15.00,
      avatarUrl:
          'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=300',
      isOnline: true,
      about:
          'Expert in drug-drug interactions, chronic diabetes insulin titration, and pediatric dosage calibration.',
      availableSlots: [
        '10:00 AM',
        '11:30 AM',
        '03:00 PM',
        '04:30 PM',
        '07:00 PM',
      ],
      languages: ['English', 'Bengali'],
    ),
    const PharmacistModel(
      id: 'pharm_2',
      name: 'Dr. Mahmudul Hasan, B.Pharm, M.S.',
      qualification: 'M.Pharm (KU), RPh',
      designation: 'Senior Community Pharmacist',
      rating: 4.8,
      reviewCount: 98,
      experienceYears: 6,
      consultationFee: 12.00,
      avatarUrl:
          'https://images.unsplash.com/photo-1622253692010-333f2da6031d?w=300',
      isOnline: true,
      about:
          'Specialized in OTC guidance, cough & cold syrup selection, sterile antiseptic care, and respiratory counseling.',
      availableSlots: ['09:30 AM', '12:00 PM', '02:30 PM', '05:00 PM'],
      languages: ['English', 'Bengali'],
    ),
    const PharmacistModel(
      id: 'pharm_3',
      name: 'Dr. Farah Nazeer, PharmD',
      qualification: 'PharmD, Clinical Fellowship (UK)',
      designation: 'Geriatric & Cardiac Care Pharmacist',
      rating: 5.0,
      reviewCount: 86,
      experienceYears: 10,
      consultationFee: 20.00,
      avatarUrl:
          'https://images.unsplash.com/photo-1594824813590-781e9b724490?w=300',
      isOnline: false,
      about:
          'Advises elderly patients on multi-drug regimens, IV saline home care, blood pressure monitoring, and kidney safety.',
      availableSlots: ['04:00 PM', '06:00 PM', '08:00 PM'],
      languages: ['English', 'Bengali'],
    ),
  ];
}
