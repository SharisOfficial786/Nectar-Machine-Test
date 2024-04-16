import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    GetMaterialApp(
      title: "Nectar Machine Test",
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      theme: ThemeData(fontFamily: 'Poppins'),
      defaultTransition: Transition.cupertino,
    ),
  );
}
