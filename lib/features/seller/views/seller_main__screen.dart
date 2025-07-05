import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SellerMainScreen extends StatefulWidget {
  @override
  State<SellerMainScreen> createState() => _SellerMainScreenState();
}

class _SellerMainScreenState extends State<SellerMainScreen> {
  int _currentIndex = 0;

  // Две вкладки (примерные)
  final List<Widget> _tabs = [
    SellerProductsScreen(),
    SellerOrdersScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Продавец'),
        centerTitle: true,
      ),
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() => _currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Мои товары',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_basket),
            label: 'Заказы',
          ),
        ],
      ),
    );
  }
}

// Экран списка товаров
class SellerProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Здесь может быть FutureBuilder/GetX-логика для списка товаров продавца
    return Center(
      child: Text('Здесь показываются товары продавца'),
    );
  }
}

// Экран списка заказов
class SellerOrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Здесь логика отображения заказов, которые пришли покупателю
    return Center(
      child: Text('Здесь показываются заказы от покупателей'),
    );
  }
}
