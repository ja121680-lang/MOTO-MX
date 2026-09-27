import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/request_ride_screen.dart';
import 'screens/driver_screen.dart';
import 'screens/admin_screen.dart';
import 'screens/driver_registration_screen.dart';
import 'screens/driver_approval_screen.dart';
import 'screens/ride_matching_screen.dart';
import 'screens/live_tracking_screen.dart';
import 'screens/fare_preview_screen.dart';
import 'screens/nearby_drivers_screen.dart';
import 'screens/wallet_screen.dart';
import 'screens/withdrawal_screen.dart';
import 'screens/diamond_screen.dart';
import 'screens/trip_history_screen.dart';
import 'screens/rating_screen.dart';
import 'screens/payment_screen.dart';
import 'theme/ga_theme.dart';
import 'widgets/ga_assistant.dart';

void main() {
  runApp(const MotoGoApp());
}

class MotoGoApp extends StatefulWidget {
  const MotoGoApp({super.key});

  @override
  State<MotoGoApp> createState() => _MotoGoAppState();
}

class _MotoGoAppState extends State<MotoGoApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: 'GA MotoGo MX',
      debugShowCheckedModeBanner: false,
      theme: GATheme.dark(),
      builder: (context, child) => GAAssistantOverlay(
        navigatorKey: _navigatorKey,
        child: child ?? const SizedBox.shrink(),
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const HomeScreen(),
        '/request': (_) => const RequestRideScreen(),
        '/driver': (_) => const DriverScreen(),
        '/admin': (_) => const AdminScreen(),
        '/driver-registration': (_) => const DriverRegistrationScreen(),
        '/driver-approval': (_) => const DriverApprovalScreen(),
        '/matching': (_) => const RideMatchingScreen(),
        '/tracking': (_) => const LiveTrackingScreen(),
        '/fare-preview': (_) => const FarePreviewScreen(),
        '/nearby-drivers': (_) => const NearbyDriversScreen(),
        '/wallet': (_) => const WalletScreen(),
        '/withdrawal': (_) => const WithdrawalScreen(),
        '/diamond': (_) => const DiamondScreen(),
        '/history': (_) => const TripHistoryScreen(),
        '/rating': (_) => const RatingScreen(),
        '/payment': (_) => const PaymentScreen(),
      },
    );
  }
}
