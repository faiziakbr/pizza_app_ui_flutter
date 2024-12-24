import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:item_count_number_button/item_count_number_button.dart';
import 'package:pizza_app_ui_flutter/modules/cart/cart_controller.dart';
import 'package:pizza_app_ui_flutter/shared/extensions/custom_snackbar.dart';
import 'package:pizza_app_ui_flutter/shared/widgets/MontserratText.dart';

class CartScreen extends GetView<CartController> {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: const MontserratText("Cart", 20, FontWeight.bold),
      ),
      body: SafeArea(
          child: Container(
        height: size.height,
        width: size.width,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Obx(() => ListView.builder(
            itemCount: controller.getList().length,
            itemBuilder: (context, index) {
              var item = controller.getList()[index];
              return Dismissible(
                key: UniqueKey(),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                onDismissed: (value) {
                  _showDialog(index);
                },
                child: SizedBox(
                  child: Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: Image.asset("assets/${item.image}"),
                          title: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              MontserratText(
                                  "${item.items[0].name}", 20, FontWeight.bold),
                            ],
                          ),
                          subtitle: item.isPromoPrice
                              ? const MontserratText(
                                  "(PROMO)", 8, FontWeight.normal,
                                  textColor: Colors.red)
                              : Container(),
                          trailing: MontserratText(
                              "\$${(item.price! * item.count).toStringAsFixed(1)}",
                              24,
                              FontWeight.bold),
                        ),
                        ItemCount(
                          initialValue: item.count,
                          step: 1,
                          color: Colors.yellow,
                          buttonSizeHeight: 40,
                          buttonSizeWidth: 60,
                          textStyle: const TextStyle(fontSize: 20),
                          minValue: 1,
                          maxValue: 10,
                          decimalPlaces: 0,
                          onChanged: (value) {
                            item.count = value.toInt();
                            controller.addCount(index, value.toInt());
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            })),
      )),
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.yellow,
          onPressed: () {
            Get.customSnackbar("Order confirmed!", "Your order will be delivered soon!");
            Future.delayed(const Duration(seconds: 1), () {
              controller.checkout();
              Get.back(closeOverlays: true);
            });
          },
          label: Obx(() => MontserratText(
              "Checkout: \$${controller.orderTotal()?.toStringAsFixed(1) ?? 0.0}",
              20,
              FontWeight.bold,
              textColor: Colors.red))),
    );
  }

  void _showDialog(int index) {
    Get.defaultDialog(
      title: "Confirmation",
      middleText: "Are you sure you want to delete this?",
      textCancel: "No",
      textConfirm: "Yes",
      backgroundColor: Colors.white,
      onCancel: () {
        controller.calculateOrderTotal();
      },
      onConfirm: () {
        controller.deleteItem(index);
        if (controller.orderTotal() == 0) {
          Get.back();
        }
        Get.back();
      },
      confirmTextColor: Colors.white,
      cancelTextColor: Colors.black,
      barrierDismissible: true,
    );
  }
}
