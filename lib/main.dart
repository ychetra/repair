import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pages/qr_scanner.dart';
import 'controllers/repair_controller.dart';
import 'controllers/repair_service.dart';
import 'controllers/auth_service.dart';
import 'pages/login_page.dart';
import 'pages/repair.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  final authService = Get.put(AuthService());
  final repairService = Get.put(RepairService(authService));
  Get.put(RepairController(repairService: repairService));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Repair App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        textTheme: GoogleFonts.figtreeTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      initialRoute: '/',
      defaultTransition: Transition.fade,
      getPages: [
        GetPage(
          name: '/login',
          page: () => LoginPage(),
        ),
        GetPage(
          name: '/',
          page: () => const Repair(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/qr-scanner',
          page: () => const QRScannerPage(),
          transition: Transition.rightToLeft,
          middlewares: [AuthMiddleware()],
        ),
      ],
    );
  }
}

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    return AuthService.to.isLoggedIn
        ? null
        : const RouteSettings(name: '/login');
  }
}
