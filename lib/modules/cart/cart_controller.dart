import 'package:get/get.dart';
import 'package:pizza_app_ui_flutter/models/menu_model.dart';
import 'package:pizza_app_ui_flutter/models/order_model.dart';


class CartController extends GetxController {

  // var menuItems = Rxn<MenuItem>();

  // final _order = OrderModel();
  var _order = Rxn<OrderModel>();
  // var count = <int>[].obs;

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
    // menuItems.add(menuItem);
    _order.value?.orderItems.add(item);
    // count.add(1);
    calculateOrderTotal();
    _order.refresh();
  }

  void addCount(int index, int value) {
    // _order.value?.orderItems[index].displayPrice =
    _order.value?.orderItems[index].count = value;
    calculateOrderTotal();
    // (_order.value!.orderItems[index].price! * value.toInt());
  }

  int orderCount() => _order.value?.orderItems.length ?? 0;

  List<OrderItemModel> getList() => _order.value?.orderItems ?? [];

  // double totalOrderPrice() {
  //   var totalPrice = 0.0;
  //   if (_order.value?.orderItems == null) {
  //     return 0;
  //   }
  //   for(var item in _order.value!.orderItems) {
  //     totalPrice += item.price ?? 0;
  //   }
  //
  //   return totalPrice;
  // }

  void calculateOrderTotal() {
    var totalPrice = 0.0;
    if (_order.value?.orderItems == null) {
      return;
    }
    for(var item in _order.value!.orderItems) {
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
}
