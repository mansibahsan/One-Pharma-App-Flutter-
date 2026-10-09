import '../models/address_model.dart';
import '../models/prescription_model.dart';
import '../models/reminder_model.dart';
import '../models/pharmacist_model.dart';
import 'package:flutter/material.dart';
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
    name: 'Mansib Ahsan',
    email: 'deom123@gmail.com',
    phone: '0569 - 8963 - 5632',
    address: 'House # 60 , Sector #12, Road# 20\nDhaka-1230',
    role: 'Pro User, Bangladesh',
  );

  static const List<CategoryModel> categories = [
    CategoryModel(
      id: 'cat_all',
      name: 'All',
      icon: Icons.grid_view_rounded,
      itemCount: 48,
      tintColor: Color(0xFFFF4858),
    ),
    CategoryModel(
      id: 'cat_ayurveda',
      name: 'Ayurveda',
      icon: Icons.spa_rounded,
      itemCount: 16,
      tintColor: Color(0xFF12B76A),
    ),
    CategoryModel(
      id: 'cat_diabetes',
      name: 'Diabetes',
      icon: Icons.bloodtype_rounded,
      itemCount: 22,
      tintColor: Color(0xFF2E90FA),
    ),
    CategoryModel(
      id: 'cat_supplements',
      name: 'Suplements',
      icon: Icons.medication_rounded,
      itemCount: 35,
      tintColor: Color(0xFFF79009),
    ),
    CategoryModel(
      id: 'cat_vitamin',
      name: 'Vitamin',
      icon: Icons.wb_sunny_rounded,
      itemCount: 29,
      tintColor: Color(0xFFEE46BC),
    ),
    CategoryModel(
      id: 'cat_baby',
      name: 'Baby Care',
      icon: Icons.child_care_rounded,
      itemCount: 14,
      tintColor: Color(0xFF7A5AF8),
    ),
  ];

  static const List<ProductModel> products = [
    ProductModel(
      id: 'prod_plastic_oi',
      name: 'Plastic oi',
      genericName: 'Cetirizine Hydrochloride',
      brand: 'Bescikos Cox',
      category: 'Suplements',
      selectedStrength: '100mg',
      availableStrengths: ['50mg', '100mg', '500mg'],
      price: 38.00,
      originalPrice: 56.00,
      discountPercent: 45,
      rating: 5.0,
      reviewCount: 128,
      isPrescriptionRequired: true,
      description:
          'Plastic oi is a prescription medicine & a preparation of Cetirizine, which is a potent antihistamine with low potential for drowsiness at pharmacologically active doses.',
      indications:
          '• Exactly as your doctor has told you\n• Recommended for seasonal allergic rhinitis, perennial allergic rhinitis, and urticaria.\n• Take with or without food as advised.',
      precautions:
          'Do not exceed recommended dose. Consult your physician if pregnant or breast-feeding.',
      packagingInfo: 'Bottle of 150 tablets',
      iconIndex: 0,
      imageUrl:
          'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=500&q=80',
      images: [
        'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=600&q=80',
        'https://images.unsplash.com/photo-1631549916768-4119b2e5f926?auto=format&fit=crop&w=600&q=80',
        'https://images.unsplash.com/photo-1550572017-edd951b55104?auto=format&fit=crop&w=600&q=80',
        'https://images.unsplash.com/photo-1584362917165-526a968579e8?auto=format&fit=crop&w=600&q=80',
      ],
    ),
    ProductModel(
      id: 'prod_eoo_cool',
      name: 'Eoo Cool',
      genericName: 'Menthol & Eucalyptus Syrup',
      brand: 'Bulbas oscan',
      category: 'Suplements',
      selectedStrength: '250mg',
      availableStrengths: ['100mg', '250mg', '500mg'],
      price: 56.00,
      originalPrice: 80.00,
      discountPercent: 45,
      rating: 5.0,
      reviewCount: 94,
      isPrescriptionRequired: false,
      description:
          'Fast-acting soothing cooling relief formula for sore throat, bronchial discomfort, and nasal passage refreshment.',
      indications:
          '• Shake well before each use\n• Take 10ml every 6 hours or as directed by healthcare provider.\n• Drink warm water afterwards.',
      precautions: 'Keep out of reach of children. Store below 25°C.',
      packagingInfo: 'Bottle of 150 tablets',
      iconIndex: 1,
      imageUrl:
          'https://images.unsplash.com/photo-1550572017-edd951b55104?auto=format&fit=crop&w=500&q=80',
      images: [
        'https://images.unsplash.com/photo-1550572017-edd951b55104?auto=format&fit=crop&w=600&q=80',
        'https://images.unsplash.com/photo-1631549916768-4119b2e5f926?auto=format&fit=crop&w=600&q=80',
        'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=600&q=80',
        'https://images.unsplash.com/photo-1512069772995-ec65ed45afd6?auto=format&fit=crop&w=600&q=80',
      ],
    ),
    ProductModel(
      id: 'prod_betulin_lux',
      name: 'Betulin Lux',
      genericName: 'Betulin Herbal Extract',
      brand: 'Kukis',
      category: 'Ayurveda',
      selectedStrength: '50mg',
      availableStrengths: ['50mg', '100mg'],
      price: 69.00,
      originalPrice: 80.00,
      discountPercent: 15,
      rating: 4.9,
      reviewCount: 76,
      isPrescriptionRequired: false,
      description:
          'Pure birch bark triterpene formulated to boost natural cellular defenses, support liver health, and enhance antioxidant capacity.',
      indications:
          '• 1 capsule daily after a morning meal.\n• Continuous cycle for 30 days recommended.',
      precautions: 'Not recommended for individuals with birch pollen allergy.',
      packagingInfo: 'Bottle of 150 tablets',
      iconIndex: 2,
      imageUrl:
          'https://images.unsplash.com/photo-1512069772995-ec65ed45afd6?auto=format&fit=crop&w=500&q=80',
      images: [
        'https://images.unsplash.com/photo-1512069772995-ec65ed45afd6?auto=format&fit=crop&w=600&q=80',
        'https://images.unsplash.com/photo-1628771065518-0d82f1938462?auto=format&fit=crop&w=600&q=80',
        'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=600&q=80',
        'https://images.unsplash.com/photo-1587854680352-936b22b91030?auto=format&fit=crop&w=600&q=80',
      ],
    ),
    ProductModel(
      id: 'prod_kusadu_lux',
      name: 'Kusadu Lux',
      genericName: 'Glucosamine Chondroitin Complex',
      brand: 'Okasa',
      category: 'Suplements',
      selectedStrength: '500mg',
      availableStrengths: ['250mg', '500mg'],
      price: 38.00,
      originalPrice: 48.00,
      discountPercent: 20,
      rating: 4.9,
      reviewCount: 110,
      isPrescriptionRequired: false,
      description:
          'High potency joint support nutrition formulated to rebuild cartilage, ease joint stiffness, and enhance flexibility.',
      indications:
          '• Take 1 tablet twice daily with meals.\n• Best results observed after 4-6 weeks of consistent use.',
      precautions: 'Individuals allergic to shellfish should consult a doctor.',
      packagingInfo: 'Bottle of 150 tablets',
      iconIndex: 3,
      imageUrl:
          'https://images.unsplash.com/photo-1471864190281-a93a3070b6de?auto=format&fit=crop&w=500&q=80',
      images: [
        'https://images.unsplash.com/photo-1471864190281-a93a3070b6de?auto=format&fit=crop&w=600&q=80',
        'https://images.unsplash.com/photo-1587854692152-cbe660dbde88?auto=format&fit=crop&w=600&q=80',
        'https://images.unsplash.com/photo-1628771065518-0d82f1938462?auto=format&fit=crop&w=600&q=80',
        'https://images.unsplash.com/photo-1584362917165-526a968579e8?auto=format&fit=crop&w=600&q=80',
      ],
    ),
    ProductModel(
      id: 'prod_goof_vitas',
      name: 'Goof vitas',
      genericName: 'Multivitamin & Minerals Complex',
      brand: 'Meuokls olo',
      category: 'Vitamin',
      selectedStrength: '50mg',
      availableStrengths: ['25mg', '50mg'],
      price: 60.00,
      originalPrice: 86.00,
      discountPercent: 45,
      rating: 5.0,
      reviewCount: 205,
      isPrescriptionRequired: false,
      description:
          'Complete daily micronutrient blend fortified with Vitamin C, D3, Zinc, and B-Complex to reinforce immunity and sustain energy.',
      indications:
          '• Take 1 tablet daily with breakfast.\n• Do not take on an empty stomach.',
      precautions: 'Do not use as a substitute for a balanced diet.',
      packagingInfo: 'Bottle of 150 tablets',
      iconIndex: 4,
      imageUrl:
          'https://images.unsplash.com/photo-1587854692152-cbe660dbde88?auto=format&fit=crop&w=500&q=80',
      images: [
        'https://images.unsplash.com/photo-1587854692152-cbe660dbde88?auto=format&fit=crop&w=600&q=80',
        'https://images.unsplash.com/photo-1512069772995-ec65ed45afd6?auto=format&fit=crop&w=600&q=80',
        'https://images.unsplash.com/photo-1584362917165-526a968579e8?auto=format&fit=crop&w=600&q=80',
        'https://images.unsplash.com/photo-1471864190281-a93a3070b6de?auto=format&fit=crop&w=600&q=80',
        'https://images.unsplash.com/photo-1628771065518-0d82f1938462?auto=format&fit=crop&w=600&q=80',
      ],
    ),
    ProductModel(
      id: 'prod_suligga_max',
      name: 'Suligga Max',
      genericName: 'Azithromycin Dihydrate',
      brand: 'Bescikos Cox',
      category: 'Suplements',
      selectedStrength: '50mg',
      availableStrengths: ['50mg', '100mg', '500mg'],
      price: 56.00,
      originalPrice: 65.00,
      discountPercent: 10,
      rating: 4.8,
      reviewCount: 88,
      isPrescriptionRequired: true,
      description:
          'Macrolide antibacterial agent designed to combat mild to moderate bacterial infections of respiratory tract and skin.',
      indications:
          '• Strictly as prescribed by registered physician.\n• Complete the entire course of medication.',
      precautions:
          'Prescription mandatory. Report immediate allergic reactions or severe diarrhea.',
      packagingInfo: 'Bottle of 150 tablets',
      iconIndex: 0,
      imageUrl:
          'https://images.unsplash.com/photo-1628771065518-0d82f1938462?auto=format&fit=crop&w=500&q=80',
      images: [
        'https://images.unsplash.com/photo-1628771065518-0d82f1938462?auto=format&fit=crop&w=600&q=80',
        'https://images.unsplash.com/photo-1587854692152-cbe660dbde88?auto=format&fit=crop&w=600&q=80',
        'https://images.unsplash.com/photo-1631549916768-4119b2e5f926?auto=format&fit=crop&w=600&q=80',
        'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=600&q=80',
      ],
    ),
  ];

  static List<CartItemModel> get initialCartItems => [
    CartItemModel(
      product: products[0], // Plastic oi
      quantity: 1,
      strength: '100mg',
      isSelected: true,
    ),
    CartItemModel(
      product: products[1], // Eoo Cool
      quantity: 1,
      strength: '250mg',
      isSelected: true,
    ),
    CartItemModel(
      product: products[2], // Betulin Lux
      quantity: 1,
      strength: '50mg',
      isSelected: true,
    ),
    CartItemModel(
      product: products[3], // Kusadu Lux
      quantity: 1,
      strength: '500mg',
      isSelected: false,
    ),
  ];

  static const List<PharmacyModel> nearbyPharmacies = [
    PharmacyModel(
      id: 'pharm_1',
      name: 'Drug Store',
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
        CartItemModel(product: products[0], quantity: 2, strength: '100mg'),
        CartItemModel(product: products[1], quantity: 1, strength: '250mg'),
      ],
      subtotal: 132.00,
      deliveryFee: 10.00,
      discount: 18.00,
      total: 124.00,
      deliveryAddress: currentUser.address,
      contactNumber: currentUser.phone,
      paymentMethod: 'Mastercard (**** 4563)',
      prescriptionUrl: 'uploaded_prescription.jpg',
      trackingTimeline: const [
        TrackingStep(
          title: 'Shipped',
          date: '31 Jan',
          time: '12:30 am',
          description: 'Order picked up and on route with rider',
          isCompleted: true,
          isCurrent: true,
        ),
        TrackingStep(
          title: 'Picked',
          date: '28 Jan',
          time: '04:10 am',
          description: 'Pharmacy packed items and assigned courier',
          isCompleted: true,
        ),
        TrackingStep(
          title: 'Processed',
          date: '26 Jan',
          time: '03:20 pm',
          description: 'Prescription verified by licensed pharmacist',
          isCompleted: true,
        ),
        TrackingStep(
          title: 'Confirming',
          date: '23 Jan',
          time: '12:30 am',
          description: 'Order confirmed and inventory reserved',
          isCompleted: true,
        ),
        TrackingStep(
          title: 'Pending',
          date: '20 Jan',
          time: '12:30 am',
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
        CartItemModel(product: products[2], quantity: 3, strength: '50mg'),
      ],
      subtotal: 207.00,
      deliveryFee: 10.00,
      discount: 0.00,
      total: 217.00,
      deliveryAddress: currentUser.address,
      contactNumber: currentUser.phone,
      paymentMethod: 'Cash on Delivery',
      trackingTimeline: const [
        TrackingStep(
          title: 'Confirming',
          date: '23 Jan',
          time: '11:15 am',
          description: 'Order awaiting pharmacy stock verification',
          isCompleted: true,
          isCurrent: true,
        ),
        TrackingStep(
          title: 'Pending',
          date: '23 Jan',
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
        CartItemModel(product: products[4], quantity: 1, strength: '50mg'),
      ],
      subtotal: 60.00,
      deliveryFee: 10.00,
      discount: 10.00,
      total: 60.00,
      deliveryAddress: currentUser.address,
      contactNumber: currentUser.phone,
      paymentMethod: 'bKash / Nagad',
      trackingTimeline: const [
        TrackingStep(
          title: 'Delivered',
          date: '15 Jan',
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
      title: 'Drug 20% off',
      message:
          'Special weekend promotion: Enjoy 20% discount on all seasonal prescription medications.',
      time: '10:14 AM',
      group: NotificationGroup.today,
      isRead: false,
    ),
    NotificationModel(
      id: 'notif_2',
      title: 'Suligga Max 10%',
      message:
          'Price drop alert! Suligga Max 50mg is now available at an extra 10% coupon rebate.',
      time: '02:30 AM',
      group: NotificationGroup.today,
      isRead: false,
    ),
    NotificationModel(
      id: 'notif_3',
      title: 'Sunday Offer',
      message:
          'Get free express doorstep delivery on all orders above \$50 placed this Sunday.',
      time: '03:18 AM',
      group: NotificationGroup.yesterday,
      isRead: true,
    ),
    NotificationModel(
      id: 'notif_4',
      title: 'Star Sunday Offer',
      message:
          'Earn 2x pharmacy loyalty stars on all essential vitamin & immunity supplements.',
      time: '04:14 AM',
      group: NotificationGroup.yesterday,
      isRead: true,
    ),
    NotificationModel(
      id: 'notif_5',
      title: 'Biggest Offers',
      message:
          'Annual health & wellness sale is now live. Explore over 500+ curated healthcare items.',
      time: '06:20 AM',
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

  // Demo Mock Data: Saved Addresses
  static List<AddressModel> get initialAddresses => [
    const AddressModel(
      id: 'addr_home',
      label: 'Home',
      recipientName: 'Hera Rahman',
      phone: '0569 - 8963 - 5632',
      streetAddress: 'House #28, Road #30, Sector #10',
      area: 'Uttara',
      city: 'Dhaka 1230',
      isDefault: true,
    ),
    const AddressModel(
      id: 'addr_office',
      label: 'Office',
      recipientName: 'Hera Rahman',
      phone: '0171 - 4567 - 8901',
      streetAddress: 'Level 8, Concord Tower, Gulshan-2',
      area: 'Gulshan',
      city: 'Dhaka 1212',
      isDefault: false,
    ),
    const AddressModel(
      id: 'addr_parents',
      label: 'Parents',
      recipientName: 'Rafiqul Rahman',
      phone: '0181 - 9876 - 5432',
      streetAddress: 'Flat 4B, Green Road, Dhanmondi',
      area: 'Dhanmondi',
      city: 'Dhaka 1205',
      isDefault: false,
    ),
  ];

  // Demo Mock Data: Wishlist
  static List<ProductModel> get initialWishlist => [
    products[2], // Betulin Lux
    products[4], // Goof vitas
  ];

  // Demo Mock Data: Prescriptions
  static List<PrescriptionModel> get initialPrescriptions => [
    PrescriptionModel(
      id: 'rx_1',
      title: 'Chest & Respiratory Care',
      doctorName: 'Dr. Shahriar Kabir, MD',
      doctorSpecialty: 'Pulmonologist & Chest Specialist',
      hospital: 'Apollo Hospitals Dhaka',
      issueDate: DateTime.now().subtract(const Duration(days: 12)),
      expiryDate: DateTime.now().add(const Duration(days: 48)),
      status: PrescriptionStatus.verified,
      fileUrl:
          'https://images.unsplash.com/photo-1584017911766-d451b3d0e843?w=500',
      linkedMedicines: [
        products[5], // Suligga Max 50mg
        products[0], // Plastic oi
      ],
      notes: 'Take with warm water after breakfast. Complete 15-day course.',
    ),
    PrescriptionModel(
      id: 'rx_2',
      title: 'Daily Liver & Antioxidant Support',
      doctorName: 'Dr. Nusrat Jahan, MBBS, FCPS',
      doctorSpecialty: 'Internal Medicine & Hepatology',
      hospital: 'Square Hospital',
      issueDate: DateTime.now().subtract(const Duration(days: 28)),
      expiryDate: DateTime.now().add(const Duration(days: 62)),
      status: PrescriptionStatus.verified,
      fileUrl:
          'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=500',
      linkedMedicines: [
        products[2], // Betulin Lux 50mg
        products[4], // Goof vitas
      ],
      notes: 'Ongoing monthly prescription for cellular immunity maintenance.',
    ),
    PrescriptionModel(
      id: 'rx_3',
      title: 'Seasonal Allergy Relief',
      doctorName: 'Dr. Anisur Rahman, MD',
      doctorSpecialty: 'Allergy & Immunology',
      hospital: 'United Hospital',
      issueDate: DateTime.now().subtract(const Duration(days: 95)),
      expiryDate: DateTime.now().subtract(const Duration(days: 5)),
      status: PrescriptionStatus.expired,
      fileUrl:
          'https://images.unsplash.com/photo-1576602976047-174e57a47881?w=500',
      linkedMedicines: [
        products[1], // Eoo Cool 250mg
      ],
      notes: 'Expired course. Consultation renewal required before refilling.',
    ),
  ];

  // Demo Mock Data: Pill Reminders
  static List<ReminderModel> get initialReminders => [
    ReminderModel(
      id: 'rem_1',
      product: products[4], // Goof vitas
      dosage: '1 Capsule',
      instruction: 'After breakfast',
      slot: ReminderTimeSlot.morning,
      time: '08:30 AM',
      isTakenToday: true,
      remainingDoses: 4, // Due for refill!
      totalDoses: 30,
    ),
    ReminderModel(
      id: 'rem_2',
      product: products[2], // Betulin Lux
      dosage: '1 Tablet',
      instruction: 'Before lunch',
      slot: ReminderTimeSlot.afternoon,
      time: '01:15 PM',
      isTakenToday: false,
      remainingDoses: 18,
      totalDoses: 30,
    ),
    ReminderModel(
      id: 'rem_3',
      product: products[5], // Suligga Max
      dosage: '1 Capsule (Rx)',
      instruction: 'With evening tea',
      slot: ReminderTimeSlot.evening,
      time: '06:30 PM',
      isTakenToday: false,
      remainingDoses: 5, // Due for refill!
      totalDoses: 15,
    ),
    ReminderModel(
      id: 'rem_4',
      product: products[1], // Eoo Cool
      dosage: '1 Tablet',
      instruction: 'Before bed',
      slot: ReminderTimeSlot.night,
      time: '10:00 PM',
      isTakenToday: false,
      remainingDoses: 22,
      totalDoses: 30,
    ),
  ];

  // Demo Mock Data: Pharmacists & Telemedicine Consultants
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
          'Expert in drug-drug interactions, chronic diabetes therapy management, and pediatric dosage calibration.',
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
          'Specialized in OTC guidance, herbal supplement compatibility, respiratory inhaler technique, and allergy counseling.',
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
          'Advises elderly patients on multi-drug regimens, blood pressure monitoring, anticoagulation regimens, and kidney safety.',
      availableSlots: ['04:00 PM', '06:00 PM', '08:00 PM'],
      languages: ['English', 'Bengali'],
    ),
  ];
}
