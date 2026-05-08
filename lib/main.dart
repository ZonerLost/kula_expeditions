import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:kuala_exp/firebase_options.dart';
import 'package:kuala_exp/routes/app_pages.dart';
import 'package:kuala_exp/routes/app_routes.dart';

import 'constants/bottom_nav_bar/bottom_nav_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Get.put(BottomNavController(), permanent: true);
  runApp(const KulaApp());
}

class KulaApp extends StatelessWidget {
  const KulaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Kula',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
      theme: ThemeData(
        fontFamily: 'ZalandoSans',
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
    );
  }
}
