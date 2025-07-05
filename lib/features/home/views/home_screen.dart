import 'package:flutter/material.dart';
import 'package:kollibry/common/themes/theme.dart';
import '../../../common/styles/colors.dart'; // Стили
import '../../../utils/device/screen_util.dart';
import '../widgets/banner_carousel.dart';
import '../widgets/category_list.dart';
import '../widgets/product_grid.dart'; // Адаптивность

class HomePage extends StatelessWidget {
  final List<String> banners = [
    'assets/images/banners/banner_1.jpg',
    'assets/images/banners/banner_2.jpg',
    'assets/images/banners/banner_3.jpg',
    'assets/images/banners/banner_4.jpg',
    'assets/images/banners/banner_5.jpg',
  ];

  final List<Map<String, String>> categories = [
    {
      'title': 'Боулинг',
      'icon': 'assets/images/category/icons8-bowling-64.png'
    },
    {
      'title': 'Косметика',
      'icon': 'assets/images/category/icons8-cosmetics-64.png'
    },
    {
      'title': 'Мебель',
      'icon': 'assets/images/category/icons8-dining-chair-64.png'
    },
    {
      'title': 'Для питомцев',
      'icon': 'assets/images/category/icons8-dog-heart-64.png'
    },
    {
      'title': 'Школьная форма',
      'icon': 'assets/images/category/icons8-school-uniform-64.png'
    },
  ];

  final List<Map<String, dynamic>> products = [
    {
      'image': 'assets/images/products/iphone_12_green.png',
      'name': 'iPhone 12',
      'description': 'Современный смартфон с мощными функциями.',
      'price': 70000.0,
    },
    {
      'image': 'assets/images/products/samsung_s9_mobile_withback.png',
      'name': 'Samsung S9',
      'description': 'Высокопроизводительный телефон для работы и развлечений.',
      'price': 50000.0,
    },
    {
      'image': 'assets/images/products/acer_laptop_var_4.png',
      'name': 'Acer Laptop',
      'description': 'Ноутбук для повседневных задач и развлечений.',
      'price': 45000.0,
    },
    {
      'image': 'assets/images/products/slipper-product.png',
      'name': 'Тапочки',
      'description': 'Удобные домашние тапочки.',
      'price': 1500.0,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                right: ScreenUtil.adaptiveWidth(8),
                left: ScreenUtil.adaptiveWidth(8),
                bottom: ScreenUtil.adaptiveWidth(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    height: ScreenUtil.adaptiveHeight(40)), // Отступ сверху
                // Поле поиска
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Искать товары...',
                    prefixIcon:
                        Icon(Icons.search, color: KColors.textSecondary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: TAppTheme.lightTheme.focusColor,
                  ),
                ),
                SizedBox(
                    height:
                        ScreenUtil.adaptiveHeight(20)), // Отступ после поиска
                // Баннеры
                BannerCarousel(banners: banners),
                SizedBox(
                    height:
                        ScreenUtil.adaptiveHeight(20)), // Отступ после баннеров
                // Категории
                CategoryList(categories: categories),
                SizedBox(
                    height: ScreenUtil.adaptiveHeight(
                        25)), // Отступ после категорий
                // Товары
                ProductGrid(products: products),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
