import 'package:get/get.dart';
import 'package:pizza_app_ui_flutter/models/order_model.dart';

class CartController extends GetxController {
  var _order = Rxn<OrderModel>();

  @override
  void onInit() {
    _order.value = OrderModel();
    super.onInit();
  }

  @override
  void onReady() {
    calculateOrderTotal();
    _order.refresh();
    super.onReady();
  }

  void addItems(OrderItemModel item) {
    _order.value?.orderItems.add(item);
    calculateOrderTotal();
    _order.refresh();
  }

  void addCount(int index, int value) {
    _order.value?.orderItems[index].count = value;
    calculateOrderTotal();
  }

  int orderCount() => _order.value?.orderItems.length ?? 0;

  List<OrderItemModel> getList() => _order.value?.orderItems ?? [];

  void calculateOrderTotal() {
    var totalPrice = 0.0;
    if (_order.value?.orderItems == null) {
      return;
    }
    for (var item in _order.value!.orderItems) {
      totalPrice += item.price! * item.count;
    }
    _order.value?.total = totalPrice;
    _order.refresh();
  }

  double? orderTotal() => _order.value?.total;

  void deleteItem(int index) {
    _order.value?.orderItems.removeAt(index);
    // count[index] = 1;
    calculateOrderTotal();
    _order.refresh();
  }

  void checkout() {
    _order.value = OrderModel();
  }
}
