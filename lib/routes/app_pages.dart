import 'package:get/get_navigation/src/routes/get_route.dart';

import '../modules/shell/main_shell_view.dart';
import '../modules/hiking_crossing/binding/hiking_details_binding.dart';
import '../modules/hiking_crossing/view/hiking_details_view.dart';
import '../modules/map/binding/map_screen_binding.dart';
import '../modules/map/view/map_screen_view.dart';
import '../modules/onboarding/binding/onboarding_binding.dart';
import '../modules/onboarding/view/onboarding_screen.dart';
import '../modules/permit/binding/permit_binding.dart';
import '../modules/permit/view/permit_view.dart';
import '../modules/permit_list/binding/permit_list_binding.dart';
import '../modules/permit_list/view/permit_list_view.dart';
import '../modules/permit_payment/binding/confirm_pay_binding.dart';
import '../modules/permit_payment/binding/permit_approved_binding.dart';
import '../modules/permit_payment/view/confirm_pay_view.dart';
import '../modules/permit_payment/view/permit_approved_view.dart';
import '../modules/permit_personal_info/binding/permit_personal_info_binding.dart';
import '../modules/permit_personal_info/view/permit_personal_info_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/view/splash_screen.dart';
import '../modules/stage_detail/binding/stage_detail_binding.dart';
import '../modules/stage_detail/view/stage_detail_view.dart';
import '../modules/stages/binding/stages_binding.dart';
import '../modules/stages/view/stages_view.dart';
import '../modules/unlock_access/binding/unlock_binding.dart';
import '../modules/unlock_access/view/unlock_activated_view.dart';
import '../modules/unlock_access/view/unlock_benefits_view.dart';
import '../modules/unlock_access/view/unlock_code_view.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = <GetPage>[
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingScreen(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: AppRoutes.shell,
      page: () => const MainShellView(),
    ),
    GetPage(
      name: AppRoutes.mapScreen,
      page: () => const MapScreenView(),
      binding: MapScreenBinding(),
    ),
    GetPage(
      name: AppRoutes.stages,
      page: () => const StagesView(),
      binding: StagesBinding(),
    ),
    GetPage(
      name: AppRoutes.stageDetail,
      page: () => const StageDetailView(),
      binding: StageDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.permit,
      page: () => const PermitView(),
      binding: PermitBinding(),
    ),
    GetPage(
      name: AppRoutes.permitPersonalInfo,
      page: () => const PermitPersonalInfoView(),
      binding: PermitPersonalInfoBinding(),
    ),
    GetPage(
      name: AppRoutes.hikingDetails,
      page: () => const HikingDetailsView(),
      binding: HikingDetailsBinding(),
    ),

    GetPage(
      name: AppRoutes.confirmPay,
      page: () => const ConfirmPayView(),
      binding: ConfirmPayBinding(),
    ),

    GetPage(
      name: AppRoutes.permitApproved,
      page: () => const PermitApprovedView(),
      binding: PermitApprovedBinding(),
    ),

    GetPage(
      name: AppRoutes.unlockCode,
      page: () => const UnlockCodeView(),
      binding: UnlockBinding(),
    ),

    GetPage(
      name: AppRoutes.unlockActivated,
      page: () => const UnlockActivatedView(),
      binding: UnlockBinding(),
    ),

    GetPage(
      name: AppRoutes.unlockBenefits,
      page: () => const UnlockBenefitsView(),
      binding: UnlockBinding(),
    ),

    GetPage(
      name: AppRoutes.permitsList,
      page: () => const PermitListView(),
      binding: PermitListBinding(),
    ),
  ];
}