import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../routes/app_routes.dart';

class AuthController extends GetxController {
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final roleController = TextEditingController(); // 'buyer' или 'seller'

  final AuthRepository _authRepository = AuthRepository();
  final box = GetStorage();

  /// Регистрация пользователя
  Future<void> register() async {
    final userName = userNameController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();
    final role = roleController.text.trim(); // 'buyer' или 'seller'

    if (userName.isEmpty || password.isEmpty || role.isEmpty) {
      Get.snackbar('Ошибка', 'Введите логин, пароль и выберите роль');
      return;
    }

    if (role != 'buyer' && role != 'seller') {
      Get.snackbar('Ошибка', 'Выберите роль: покупатель или продавец');
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar('Ошибка', 'Пароли не совпадают');
      return;
    }

    try {
      await _authRepository.register(userName, password, role);
      Get.snackbar('Успех', 'Вы успешно зарегистрировались');

      box.write('loggedIn', true);
      box.write('role', role);

      if (role == 'seller') {
        Get.offAllNamed(AppRoutes.sellerHome);
      } else {
        Get.offAllNamed(AppRoutes.home);
      }
    } catch (e) {
      Get.snackbar('Ошибка', e.toString());
    }
  }

  /// Авторизация
  Future<void> login() async {
    final userName = userNameController.text.trim();
    final password = passwordController.text.trim();

    if (userName.isEmpty || password.isEmpty) {
      Get.snackbar('Ошибка', 'Введите логин и пароль');
      return;
    }

    try {
      final userData = await _authRepository.login(userName, password);
      final role = userData['role'] ?? 'buyer';

      Get.snackbar('Успех', 'Вы успешно вошли');

      box.write('loggedIn', true);
      box.write('role', role);

      if (role == 'seller') {
        Get.offAllNamed(AppRoutes.sellerHome);
      } else {
        Get.offAllNamed(AppRoutes.home);
      }
    } catch (e) {
      Get.snackbar('Ошибка', e.toString());
    }
  }

  /// Сброс пароля — если ваше API это поддерживает
  Future<void> resetPassword() async {
    // ...
  }

  /// Выход
  void logout() {
    box.remove('loggedIn');
    box.remove('role');
    Get.offAllNamed(AppRoutes.login);
  }
}
