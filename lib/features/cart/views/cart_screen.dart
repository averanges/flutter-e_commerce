import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/themes/theme.dart';
import '../../../utils/device/screen_util.dart';
import '../../orders/views/order_details_screen.dart';
import '../controllers/cart_controller.dart';

class CartScreen extends StatelessWidget {
  final CartController cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (cartController.cartItems.isEmpty) {
          return Center(
            child: Text(
              "Корзина пуста",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.all(18.0),
          child: ListView.builder(
            itemCount: cartController.cartItems.length,
            itemBuilder: (context, index) {
              final product = cartController.cartItems[index];
              return ListTile(
                leading: Image.asset(
                  product['image'],
                  width: ScreenUtil.adaptiveWidth(50),
                  height: ScreenUtil.adaptiveHeight(50),
                ),
                title: Text(
                  product['name'],
                  style: TAppTheme.lightTheme.textTheme.titleMedium,
                ),
                subtitle: Text(
                  "${product['price']} ₽",
                  style: TAppTheme.lightTheme.textTheme.labelMedium,
                ),
                onTap: () {
                  Get.to(() => OrderDetailsScreen(
                        imageUrl: product['image'],
                        name: product['name'],
                        description: product['description'],
                        price: product['price'],
                      ));
                },
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    cartController.removeFromCart(product);
                  },
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
