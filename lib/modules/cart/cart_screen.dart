import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pizza_app_ui_flutter/modules/cart/cart_controller.dart';
import 'package:pizza_app_ui_flutter/shared/widgets/MontserratText.dart';

class CartScreen extends GetView<CartController> {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
          child: Container(
        height: size.height,
        width: size.width,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: ListView.builder(
          itemCount: controller.getList().length,
            itemBuilder: (context, index) {
            var item = controller.getList()[index];
            return Card(
              child: ListTile(
                title: MontserratText("${item.boxes.length}", 20, FontWeight.bold),
              ),
            );
        }),
      )),
    );
  }
}
