import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kuala_exp/routes/app_pages.dart';
import 'package:kuala_exp/routes/app_routes.dart';

import 'constants/bottom_nav_bar/bottom_nav_controller.dart';

void main() {
  Get.put(BottomNavController(), permanent: true);
  runApp(const kuala_exp());
}

class kuala_exp extends StatelessWidget {
  const kuala_exp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Kula',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
      theme: ThemeData(
        fontFamily: "ZalandoSans",
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
    );
  }
}
