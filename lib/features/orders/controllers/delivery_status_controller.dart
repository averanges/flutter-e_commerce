import 'package:get/get.dart';
import 'dart:async';
import '../views/order_list_screen.dart';

/// Контроллер состояния доставки для управления процессом выполнения заказа.
/// Использует GetX для управления состоянием и навигации.
class DeliveryStatusController extends GetxController {
  /// Текущее состояние доставки, представлено как индекс статуса в списке.
  var currentStep = 0.obs;

  /// Список статусов доставки, которые будут обновляться по таймеру.
  final List<String> statuses = [
    'Заказ формируется', // 0
    'Дрон вылетел за заказом', // 1
    'Дрон в пути к вам', // 2
    'Через 3 минуты заказ прибудет', // 3
    'Заказ на месте, заберите груз' // 4
  ];

  @override
  void onInit() {
    super.onInit();
    startDeliveryProcess(); // Запуск процесса отслеживания доставки при инициализации контроллера.
  }

  /// Метод запускает процесс изменения статусов доставки с определенными задержками.
  void startDeliveryProcess() {
    // Список временных задержек для изменения статуса
    const durations = [
      Duration(seconds: 5), // Отображение "Дрон вылетел за заказом"
      Duration(seconds: 5), // Отображение "Дрон в пути к вам"
      Duration(seconds: 7), // Отображение "Через 3 минуты заказ прибудет"
      Duration(seconds: 5), // Отображение "Заказ на месте, заберите груз"
    ];

    // Цикл по временным задержкам для обновления статуса доставки
    for (int i = 0; i < durations.length; i++) {
      Future.delayed(
        // Вычисление общей задержки до конкретного шага
        durations.take(i + 1).fold(Duration.zero, (a, b) => a + b),
        () {
          if (!currentStep.isNull) {
            currentStep.value = i + 1; // Обновление текущего шага статуса
          }
        },
      );
    }

    // Финальное действие: переход на экран завершения доставки
    Future.delayed(
      durations.reduce((a, b) => a + b), // Общая сумма всех задержек
      () {
        if (Get.isRegistered<DeliveryStatusController>()) {
          Get.off(() =>
              DeliveryCompletedScreen()); // Переключение на экран завершения заказа
        }
      },
    );
  }
}
