import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:heyfood_note_test/controller/theme_controlller.dart';
import 'package:heyfood_note_test/core/constants.dart';
import 'package:heyfood_note_test/screens/homepage.dart';

void main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) {
        return Obx(() => GetMaterialApp(
            debugShowCheckedModeBanner: false,
            darkTheme: AppThemes.dark,
            themeMode: themeController.isDarkMode.value
                ? ThemeMode.dark
                : ThemeMode.light,
            theme: AppThemes.light,
            title: 'Flutter Demo',
            // theme: ThemeData(
            //   fontFamily: 'AvenirLTStd-Light',
            //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            //   useMaterial3: true,
            // ),
            home: const Homepage()));
      },
    );
  }
}
