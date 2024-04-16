import 'package:get/get.dart';
import 'package:machine_test_nectar/app/modules/create/bindings/create_binding.dart';
import 'package:machine_test_nectar/app/modules/create/views/create_view.dart';
import 'package:machine_test_nectar/app/modules/details/bindings/details_binding.dart';
import 'package:machine_test_nectar/app/modules/details/views/pdf_view.dart';
import 'package:machine_test_nectar/app/modules/details/views/video_player_view.dart';
import 'package:machine_test_nectar/app/modules/splash/bindings/splash_binding.dart';
import 'package:machine_test_nectar/app/modules/splash/views/splash_view.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.splash;

  static final routes = [
     GetPage(
      name: _Paths.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.create,
      page: () => const CreateView(),
      binding: CreateBinding(),
    ),
    GetPage(
      name: _Paths.pdf,
      page: () => const PdfView(),
      binding: DetailsBinding(),
    ),
     GetPage(
      name: _Paths.video,
      page: () => const VideoPlayerView(),
      binding: DetailsBinding(),
    ),
  ];
}
