/// Файл маршрутов для всего приложения.
/// Используется в `GetMaterialApp` для управления навигацией.
import 'package:get/get.dart'; // Импорт GetX для маршрутов и состояния
// Импорты страниц и маршрутов приложения
import '../features/auth/views/login_screen.dart'; // Экран авторизации
import '../features/auth/views/registration_screen.dart'; // Экран регистрации
import '../features/auth/views/forgot_password_screen.dart'; // Экран восстановления пароля
import '../features/home/views/main_screen.dart'; // Главная страница приложения
import '../features/onboarding/views/onboarding_screen.dart'; // Страницы онбординга
import '../features/orders/views/order_list_screen.dart';
import '../features/profile/views/delivery_point_screen.dart';
import '../features/profile/views/edit_profile_screen.dart';
import '../features/profile/views/profile_screen.dart';
import '../features/seller/views/seller_main__screen.dart';

class AppRoutes {
  static const String login = '/login'; // Маршрут для экрана авторизации
  static const String register = '/register'; // Маршрут для экрана регистрации
  static const String forgotPassword =
      '/forgot-password'; // Маршрут для экрана восстановления пароля
  static const String home = '/home'; // Маршрут для главного экрана
  static const String onboarding = '/onboarding'; // Онбординг
  static const String profile = '/profile'; // Профиль
  static const String profileEdit = '/edit-profile'; // Редактирование профиля
  static const String deliveryPoint = '/delivery-point'; // Точка доставки
  static const String notFound =
      '/not-found'; // Обработчик неизвестных маршрутов
  static const String deliveryCompleted =
      '/deliv-complet'; // Заказ доставлен открыть
  static const String sellerHome = '/seller-home'; // Продавецкий экран

  static final List<GetPage> pages = [
    GetPage(name: login, page: () => LoginScreen()),
    GetPage(name: register, page: () => RegistrationScreen()),
    GetPage(name: forgotPassword, page: () => ForgotPasswordScreen()),
    GetPage(name: home, page: () => MainScreen()),
    GetPage(name: onboarding, page: () => OnboardingScreen()),
    GetPage(name: profile, page: () => ProfileScreen()),
    GetPage(name: profileEdit, page: () => EditProfileScreen()),
    GetPage(name: deliveryPoint, page: () => DeliveryPointScreen()),
    GetPage(name: deliveryPoint, page: () => DeliveryCompletedScreen()),
    GetPage(name: sellerHome, page: () => SellerMainScreen()), // продавец
  ];
}
