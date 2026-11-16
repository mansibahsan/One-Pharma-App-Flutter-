import 'package:go_router/go_router.dart';
import 'package:one_pharma/presentation/screens/splash/splash_screen.dart';
import 'package:one_pharma/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:one_pharma/presentation/screens/auth/auth_gateway_screen.dart';
import 'package:one_pharma/presentation/screens/auth/sign_in_screen.dart';
import 'package:one_pharma/presentation/screens/auth/sign_up_screen.dart';
import 'package:one_pharma/presentation/screens/auth/otp_verification_screen.dart';
import 'package:one_pharma/presentation/screens/auth/verification_success_screen.dart';
import 'package:one_pharma/presentation/screens/shell/main_shell_screen.dart';
import 'package:one_pharma/presentation/screens/catalog/product_details_screen.dart';
import 'package:one_pharma/presentation/screens/catalog/category_products_screen.dart';
import 'package:one_pharma/presentation/screens/checkout/checkout_screen.dart';
import 'package:one_pharma/presentation/screens/checkout/order_success_screen.dart';
import 'package:one_pharma/presentation/screens/orders/order_tracking_screen.dart';
import 'package:one_pharma/presentation/screens/prescription/prescription_upload_screen.dart';
import 'package:one_pharma/presentation/screens/prescription/prescription_vault_screen.dart';
import 'package:one_pharma/presentation/screens/prescription/prescription_detail_screen.dart';
import 'package:one_pharma/presentation/screens/reminders/reminders_screen.dart';
import 'package:one_pharma/presentation/screens/reminders/add_reminder_screen.dart';
import 'package:one_pharma/presentation/screens/consult/pharmacists_screen.dart';
import 'package:one_pharma/presentation/screens/consult/pharmacist_profile_screen.dart';
import 'package:one_pharma/presentation/screens/address/addresses_screen.dart';
import 'package:one_pharma/presentation/screens/address/add_address_screen.dart';
import 'package:one_pharma/presentation/screens/wishlist/wishlist_screen.dart';
import 'package:one_pharma/presentation/screens/search/search_screen.dart';
import 'package:one_pharma/presentation/screens/profile/profile_screen.dart';
import 'package:one_pharma/presentation/screens/profile/review_screen.dart';
import 'package:one_pharma/presentation/screens/notifications/notifications_screen.dart';
import 'package:one_pharma/presentation/screens/support/support_chat_screen.dart';
import 'package:one_pharma/presentation/screens/doctor/doctor_shell_screen.dart';
import 'package:one_pharma/presentation/screens/doctor/write_prescription_screen.dart';
import 'package:one_pharma/presentation/screens/consult/teleconsult_call_screen.dart';
import 'package:one_pharma/data/models/user_model.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/auth-gateway',
      builder: (context, state) => const AuthGatewayScreen(),
    ),
    GoRoute(
      path: '/sign-in',
      builder: (context, state) {
        final roleParam = state.uri.queryParameters['role'];
        final initialRole =
            roleParam == 'doctor' ? UserRole.doctor : UserRole.patient;
        return SignInScreen(initialRole: initialRole);
      },
    ),
    GoRoute(
      path: '/sign-up',
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: '/otp-verification',
      builder: (context, state) => const OtpVerificationScreen(),
    ),
    GoRoute(
      path: '/verification-success',
      builder: (context, state) => const VerificationSuccessScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const MainShellScreen(initialTab: 0),
    ),
    GoRoute(
      path: '/map',
      builder: (context, state) => const MainShellScreen(initialTab: 1),
    ),
    GoRoute(
      path: '/cart',
      builder: (context, state) => const MainShellScreen(initialTab: 2),
    ),
    GoRoute(
      path: '/orders',
      builder: (context, state) => const MainShellScreen(initialTab: 4),
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) => const SearchScreen(),
    ),
    GoRoute(
      path: '/product/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return ProductDetailsScreen(productId: id);
      },
    ),
    GoRoute(
      path: '/category/:name',
      builder: (context, state) {
        final name = state.pathParameters['name'] ?? 'All';
        return CategoryProductsScreen(categoryName: name);
      },
    ),
    GoRoute(
      path: '/checkout',
      builder: (context, state) => const CheckoutScreen(),
    ),
    GoRoute(
      path: '/order-success',
      builder: (context, state) => const OrderSuccessScreen(),
    ),
    GoRoute(
      path: '/order-tracking',
      builder: (context, state) => const OrderTrackingScreen(),
    ),
    GoRoute(
      path: '/prescription-upload',
      builder: (context, state) => const PrescriptionUploadScreen(),
    ),
    GoRoute(
      path: '/prescriptions',
      builder: (context, state) => const PrescriptionVaultScreen(),
    ),
    GoRoute(
      path: '/prescriptions/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return PrescriptionDetailScreen(prescriptionId: id);
      },
    ),
    GoRoute(
      path: '/reminders',
      builder: (context, state) => const RemindersScreen(),
    ),
    GoRoute(
      path: '/add-reminder',
      builder: (context, state) => const AddReminderScreen(),
    ),
    GoRoute(
      path: '/consult',
      builder: (context, state) => const PharmacistsScreen(),
    ),
    GoRoute(
      path: '/consult/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return PharmacistProfileScreen(pharmacistId: id);
      },
    ),
    GoRoute(
      path: '/addresses',
      builder: (context, state) => const AddressesScreen(),
    ),
    GoRoute(
      path: '/add-address',
      builder: (context, state) => const AddAddressScreen(),
    ),
    GoRoute(
      path: '/wishlist',
      builder: (context, state) => const WishlistScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/review',
      builder: (context, state) => const ReviewScreen(),
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationsScreen(),
    ),
    GoRoute(
      path: '/support-chat',
      builder: (context, state) => const SupportChatScreen(),
    ),
    GoRoute(
      path: '/doctor',
      builder: (context, state) => const DoctorShellScreen(),
    ),
    GoRoute(
      path: '/doctor/write-rx',
      builder: (context, state) {
        final patient = state.uri.queryParameters['patient'];
        return WritePrescriptionScreen(initialPatientName: patient);
      },
    ),
    GoRoute(
      path: '/teleconsult-call',
      builder: (context, state) => const TeleconsultCallScreen(),
    ),
  ],
);
