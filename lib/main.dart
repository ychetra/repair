import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:repair/pages/home.dart';
import 'package:repair/pages/qr_scanner.dart';
import 'package:repair/controllers/home_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(HomeController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QR Scanner Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      defaultTransition: Transition.fade,
      getPages: [
        GetPage(
          name: '/',
          page: () => const HomePage(),
        ),
        GetPage(
          name: '/qr-scanner',
          page: () => const QRScannerPage(),
          transition: Transition.rightToLeft,
        ),
      ],
    );
  }
}
