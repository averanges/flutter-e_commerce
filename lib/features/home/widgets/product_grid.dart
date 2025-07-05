import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kollibry/common/themes/theme.dart';
import '../../../../utils/device/screen_util.dart';
import '../../buyer/product_card/views/product_card_screen.dart';
import '../../cart/controllers/cart_controller.dart';

class ProductGrid extends StatelessWidget {
  final List<Map<String, dynamic>> products;

  const ProductGrid({required this.products});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: ScreenUtil.adaptiveWidth(10),
        mainAxisSpacing: ScreenUtil.adaptiveHeight(10),
        childAspectRatio: 0.8,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return GestureDetector(
          onTap: () {
            // Переход на экран карточки товара
            Get.to(() => ProductCardScreen(
                  imageUrl: product['image'],
                  name: product['name'],
                  description:
                      product['description'] ?? 'Описание отсутствует.',
                  price: product['price'],
                ));
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: TAppTheme.lightTheme.hintColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                      image: DecorationImage(
                        image: AssetImage(product['image']),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: ScreenUtil.adaptiveWidth(6),
                      left: ScreenUtil.adaptiveWidth(6)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product['name'],
                        style: TAppTheme.lightTheme.textTheme.labelMedium,
                      ),
                      Text(
                        "${product['price']} ₽",
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.blue),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: Icon(Icons.add_shopping_cart,
                              color: Colors.green),
                          onPressed: () {
                            final cartController = Get.find<CartController>();
                            cartController.addToCart(product);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
