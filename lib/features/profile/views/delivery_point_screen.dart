import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kollibry/common/themes/theme.dart';
import 'package:latlong2/latlong.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../../../common/styles/colors.dart';
import '../../orders/views/delivery_status_screen.dart';

/// Экран выбора точки доставки
class DeliveryPointScreen extends StatefulWidget {
  @override
  _DeliveryPointScreenState createState() => _DeliveryPointScreenState();
}

class _DeliveryPointScreenState extends State<DeliveryPointScreen> {
  // Контроллер для управления картой
  final MapController _mapController = MapController();
  // Контроллер для поля поиска адреса
  final TextEditingController _searchController = TextEditingController();
  // Экземпляр Location для работы с GPS
  Location _location = Location();
  // Текущее местоположение пользователя
  LatLng? _currentPosition;
  // Координаты по умолчанию (Санкт-Петербург)
  LatLng _defaultPosition = LatLng(59.9343, 30.3351);
  // Маркер, обозначающий выбранную точку доставки
  Marker? _deliveryMarker;

  // Список вариантов адресов
  List<Map<String, dynamic>> _suggestions = [];

  // Локальное хранилище для истории поиска
  final GetStorage _storage = GetStorage();
  List<String> _searchHistory = [];

  @override
  void initState() {
    super.initState();
    _checkAndRequestPermissions(); // Проверяем разрешения на геолокацию при запуске экрана
    _loadSearchHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Точка доставки',
          style: TAppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        backgroundColor: KColors.primary,
      ),
      body: Stack(
        children: [
          /// Карта с возможностью выбора точки доставки
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentPosition ?? _defaultPosition,
              initialZoom: 12.0,
              // Установка маркера при клике на карту
              onTap: (tapPosition, point) {
                _updateDeliveryPoint(point);
              },
            ),
            children: [
              /// Слой с картами OpenStreetMap
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              ),

              /// Слой с маркером доставки (если он установлен)
              if (_deliveryMarker != null)
                MarkerLayer(
                  markers: [_deliveryMarker!],
                ),
            ],
          ),

          /// Поле поиска адреса
          Positioned(
            top: 10,
            left: 20,
            right: 20,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: "Введите адрес...",
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: _searchLocation,
                      ),
                    ),
                    onChanged: (text) => _fetchAddressSuggestions(text),
                    onSubmitted: (_) => _searchLocation(),
                  ),
                ),

                /// Отображение предложенных адресов и истории поиска
                _suggestions.isNotEmpty || _searchHistory.isNotEmpty
                    ? Container(
                        color: Colors.white,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount:
                              _suggestions.length + _searchHistory.length,
                          itemBuilder: (context, index) {
                            if (index < _searchHistory.length) {
                              // Отображение истории поиска
                              final historyItem = _searchHistory[index];
                              return ListTile(
                                leading:
                                    Icon(Icons.history, color: KColors.primary),
                                title: Text(historyItem),
                                onTap: () {
                                  _searchController.text = historyItem;
                                  _searchLocation();
                                },
                              );
                            } else {
                              // Отображение предложенных адресов
                              final suggestionIndex =
                                  index - _searchHistory.length;
                              final suggestion = _suggestions[suggestionIndex];
                              return ListTile(
                                leading: Icon(Icons.location_on,
                                    color: KColors.primary),
                                title: Text(suggestion['display_name']),
                                onTap: () {
                                  _searchController.text =
                                      suggestion['display_name'];
                                  _searchLocation();
                                },
                              );
                            }
                          },
                        ),
                      )
                    : SizedBox.shrink(),
              ],
            ),
          ),

          /// Кнопки управления картой
          Positioned(
            bottom: 20,
            right: 20,
            child: Column(
              children: [
                /// Кнопка для получения текущего местоположения
                FloatingActionButton(
                  backgroundColor: KColors.primary,
                  onPressed: _getCurrentLocation,
                  child: const Icon(Icons.my_location, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Проверка и запрос разрешений на геолокацию
  Future<void> _checkAndRequestPermissions() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // Проверяем, включена ли служба GPS
    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        Get.snackbar('Ошибка', 'Необходимо включить GPS');
        return;
      }
    }

    // Проверяем, есть ли разрешение на доступ к геолокации
    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        Get.snackbar('Ошибка', 'Необходимо разрешение на геолокацию');
        return;
      }
    }
  }

  /// Получение списка адресов для автоподсказки
  Future<void> _fetchAddressSuggestions(String query) async {
    if (query.isEmpty) {
      setState(() {
        _suggestions.clear();
      });
      return;
    }

    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=$query&format=json&addressdetails=1');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      setState(() {
        _suggestions = data.cast<Map<String, dynamic>>();
      });
    }
  }

  /// Получение текущего местоположения пользователя
  Future<void> _getCurrentLocation() async {
    try {
      LocationData locationData = await _location.getLocation();
      final LatLng newLocation =
          LatLng(locationData.latitude!, locationData.longitude!);

      setState(() {
        _currentPosition = newLocation;
        _updateDeliveryPoint(newLocation);
      });

      _mapController.move(newLocation, 16.0);

      Get.snackbar(
        duration: Duration(seconds: 2),
        'Успешно',
        'Местоположение определено: ${newLocation.latitude}, ${newLocation.longitude}',
      );
    } catch (e) {
      Get.snackbar(
          duration: Duration(seconds: 2),
          'Ошибка',
          'Не удалось получить текущее местоположение');
    }
  }

  /// Поиск местоположения по введенному адресу
  Future<void> _searchLocation() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      Get.snackbar('Ошибка', 'Введите адрес для поиска');
      return;
    }

    // Отправляем запрос к API Nominatim (OpenStreetMap)
    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=$query&format=json');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      if (data.isNotEmpty) {
        final double lat = double.parse(data[0]['lat']);
        final double lon = double.parse(data[0]['lon']);
        final LatLng newLocation = LatLng(lat, lon);

        setState(() {
          _currentPosition = newLocation;
          _updateDeliveryPoint(newLocation);
          _suggestions.clear(); // Очищаем список предложенных адресов
        });

        _mapController.move(newLocation, 16.0);

        _saveSearchHistory(query);

        Get.snackbar(
            duration: Duration(seconds: 2), 'Успешно', 'Найден адрес: $query');
      } else {
        Get.snackbar('Ошибка', 'Адрес не найден');
      }
    } else {
      Get.snackbar('Ошибка', 'Ошибка при выполнении запроса');
    }
  }

  /// Открытие координат в Яндекс.Картах
  Future<void> _openInYandexMaps() async {
    if (_currentPosition == null) {
      Get.snackbar('Ошибка', 'Сначала выберите местоположение');
      return;
    }

    final url =
        'https://yandex.ru/maps/?ll=${_currentPosition!.longitude},${_currentPosition!.latitude}&z=16';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Get.snackbar('Ошибка', 'Не удалось открыть Яндекс.Карты');
    }
  }

  /// Устанавливает маркер точки доставки на карте
  void _updateDeliveryPoint(LatLng point) async {
    setState(() {
      _deliveryMarker = Marker(
        point: point,
        width: 40,
        height: 40,
        child: const Icon(
          Icons.location_pin,
          color: Colors.red,
          size: 40,
        ),
      );
    });

    // Перемещаем карту к новому маркеру
    _mapController.move(point, 16.0);

    // Запрашиваем адрес по координатам
    String address = await _getAddressFromLatLng(point);

    // Показываем окно подтверждения с адресом
    _showOrderConfirmationDialog(address, point);

    // Get.snackbar(
    //     duration: Duration(seconds: 2),
    //     'Точка выбрана',
    //     '${point.latitude}, ${point.longitude}');
  }

  /// Сохранение истории поиска (до 3 последних запросов)
  void _saveSearchHistory(String query) {
    _searchHistory.remove(query);
    _searchHistory.insert(0, query);
    if (_searchHistory.length > 2) {
      _searchHistory.removeLast();
    }
    _storage.write('searchHistory', _searchHistory);
  }

  /// Загрузка истории поиска из локального хранилища
  void _loadSearchHistory() {
    _searchHistory = _storage.read<List>('searchHistory')?.cast<String>() ?? [];
  }

  /// Показывает окно подтверждения заказа
  /// Показывает окно подтверждения заказа с адресом
  void _showOrderConfirmationDialog(String address, LatLng point) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Подтвердите заказ",
            style: TextStyle(color: Colors.black),
          ),
          content: Text(
              "Вы выбрали точку:\n$address\n\nВы хотите оформить заказ?",
              style: TextStyle(color: Colors.black)),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context), // Закрыть окно
                  child: Text(
                    "Отмена",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Get.to(DeliveryStatusScreen());
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: KColors.buttonDark),
                  child: Text("Заказать"),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  /// Логика оформления заказа (здесь можно отправить данные на сервер)
  /// Оформление заказа с адресом
  void _placeOrder(String address, LatLng point) {
    Get.snackbar(
      "Заказ оформлен",
      "Точка доставки: $address",
      duration: Duration(seconds: 3),
      backgroundColor: KColors.buttonDark,
      colorText: Colors.white,
    );

    // Здесь можно добавить отправку данных на сервер
    print(
        "Заказ отправлен: Адрес=$address, Lat=${point.latitude}, Lon=${point.longitude}");
  }

  /// Получает адрес по координатам с помощью API Nominatim (OpenStreetMap)
  Future<String> _getAddressFromLatLng(LatLng point) async {
    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?lat=${point.latitude}&lon=${point.longitude}&format=json');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final address = data['display_name']; // Полный адрес
        return address ?? "Адрес не найден";
      } else {
        return "Ошибка загрузки адреса";
      }
    } catch (e) {
      return "Ошибка сети: $e";
    }
  }
}

// SizedBox(height: 10),
                // FloatingActionButton(
                //   backgroundColor: KColors.primary,
                //   onPressed: _openInYandexMaps,
                //   child: const Icon(Icons.map, color: Colors.white),
                // ),