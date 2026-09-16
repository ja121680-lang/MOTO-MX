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

void main() {
  runApp(const MotoGoApp());
}

class MotoGoApp extends StatelessWidget {
  const MotoGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MotoGo MX',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
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
