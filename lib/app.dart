// Главный класс приложения
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'common/themes/theme.dart';
import 'routes/app_routes.dart';

class App extends StatelessWidget {
  App({super.key});

  @override
  Widget build(BuildContext context) {
    // final box = GetStorage();
    // bool isLoggedIn = box.read('loggedIn') ?? false;
    // final String role = box.read('role') ?? 'buyer';

    // Если пользователь не авторизован, идём на логин.
    // Если авторизован и роль - 'seller', идём на SellerMainScreen.
    // Иначе - на обычный MainScreen.
    final initialRoute = AppRoutes.home;
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.lightTheme, // Установка темной темы (по умолчанию)
      initialRoute: initialRoute, // Указание начального маршрута
      getPages: AppRoutes.pages, // Передача списка маршрутов в GetMaterialApp
      unknownRoute: GetPage(
        name: AppRoutes.notFound,
        page: () => Scaffold(
          body: Center(
            child: Text('Маршрут не найден'),
          ),
        ),
      ),
    );
  }
}
