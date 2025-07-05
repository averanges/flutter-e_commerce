import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/styles/colors.dart';
import '../../../../common/styles/sizes.dart';
import '../../../../common/themes/text_theme.dart';
import '../../../../utils/device/screen_util.dart';
import '../controllers/product_card_controller.dart';

class ProductCardScreen extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String description;
  final double price;

  ProductCardScreen({
    required this.imageUrl,
    required this.name,
    required this.description,
    required this.price,
  });

  final ProductCardController controller = Get.put(ProductCardController());

  @override
  Widget build(BuildContext context) {
    final product = {
      'image': imageUrl,
      'name': name,
      'description': description,
      'price': price,
    };
    return Scaffold(
      backgroundColor: KColors.backgroundLight,
      appBar: AppBar(
        title: Text(name, style: Theme.of(context).textTheme.titleLarge),
        backgroundColor: KColors.primary,
      ),
      body: Padding(
        padding: EdgeInsets.all(ScreenUtil.adaptiveWidth(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Картинка товара
            Center(
              child: Container(
                height: ScreenUtil.percentHeight(50),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(KSizes.md),
                  image: DecorationImage(
                    image: AssetImage(imageUrl),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            SizedBox(height: ScreenUtil.adaptiveHeight(20)),

            // Название товара
            Text(
              name,
              style: KTextTheme.darkTextTheme.headlineLarge,
            ),
            SizedBox(height: ScreenUtil.adaptiveHeight(10)),

            // Цена товара
            Text(
              "${price.toStringAsFixed(2)} ₽",
              style: KTextTheme.lightTextTheme.titleMedium,
            ),
            SizedBox(height: ScreenUtil.adaptiveHeight(20)),

            // Описание товара
            Text(
              description,
              style: KTextTheme.lightTextTheme.titleMedium,
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: ScreenUtil.adaptiveHeight(30)),

            // Кнопки "Добавить в корзину" и "Добавить в избранное"
            Row(
              children: [
                Expanded(
                  child: Obx(
                    () => ElevatedButton(
                      onPressed: () => controller.toggleCartStatus(product),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: KColors.primary,
                        padding: EdgeInsets.symmetric(
                            vertical: ScreenUtil.adaptiveHeight(15),
                            horizontal: ScreenUtil.adaptiveHeight(5)),
                      ),
                      child: Text(
                        controller.isInCart.value
                            ? "Убрать из корзины"
                            : "Добавить в корзину",
                        style: KTextTheme.darkTextTheme.bodyLarge,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: ScreenUtil.adaptiveWidth(10)),
                Expanded(
                  child: Obx(
                    () => OutlinedButton(
                      onPressed: controller.toggleFavoriteStatus,
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            vertical: ScreenUtil.adaptiveHeight(8),
                            horizontal: ScreenUtil.adaptiveHeight(5)),
                        side: BorderSide(color: KColors.primary),
                      ),
                      child: Text(
                        controller.isInFavorites.value
                            ? "Убрать из избранного"
                            : "Добавить в избранное",
                        style: KTextTheme.lightTextTheme.titleMedium,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
