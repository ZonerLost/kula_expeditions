import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../../../constants/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../../onboarding/services/map_package_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      MapboxOptions.setAccessToken(dotenv.env['MAPBOX_ACCESS_TOKEN'] ?? '');
      await Future.delayed(const Duration(seconds: 2));
      await _navigate();
    });
  }

  Future<void> _navigate() async {
    debugPrint('[Splash] Checking map download status...');
    final package = await MapPackageService.fetchPackage();
    if (package != null &&
        package.isActive &&
        await MapPackageService.isDownloaded(package.version)) {
      debugPrint('[Splash] Map is downloaded. Navigating to shell...');
      Get.offNamed(AppRoutes.shell);
    } else {
      debugPrint('[Splash] Map not downloaded. Navigating to onboarding...');
      Get.offNamed(AppRoutes.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryBgTop,
              AppColors.primaryBgBottom,
            ],
          ),
        ),
      ),
    );
  }
}
