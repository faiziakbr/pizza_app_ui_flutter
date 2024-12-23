import 'package:get/get.dart';
import 'package:pizza_app_ui_flutter/models/menu_model.dart';
import 'package:pizza_app_ui_flutter/models/order_model.dart';


class CartController extends GetxController {

  // var menuItems = Rxn<MenuItem>();

  // final _order = OrderModel();
  var _order = Rxn<OrderModel>();

  @override
  void onInit() {
    _order.value = OrderModel();
    super.onInit();
  }

  void addItems(OrderItemModel item) {
    // menuItems.add(menuItem);
    _order.value?.orderItems.add(item);
    _order.refresh();
  }

  int orderCount() => _order.value?.orderItems.length ?? 0;

  List<OrderItemModel> getList() => _order.value?.orderItems ?? [];
}
