import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pizza_app_ui_flutter/models/topping_model.dart';
import 'package:pizza_app_ui_flutter/modules/selection/selection_controller.dart';
import 'package:pizza_app_ui_flutter/shared/widgets/custom_button.dart';

class SelectionScreen extends GetView<SelectionController> {
  const SelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
          child: Container(
              height: size.height,
              width: size.width,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: controller.obx((pizzaDetails) {
                var details = pizzaDetails;
                if (details == null) return Container();
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      CarouselSlider.builder(
                        options: CarouselOptions(
                            enableInfiniteScroll: false,
                            initialPage: 0,
                            animateToClosest: true,
                            height: size.height * 0.4,
                            onPageChanged: (index, reason) {
                              var selectedSize = details.sizes[index];
                              controller.menuItem.size = selectedSize;
                              controller.itemPrice.value = selectedSize.price;
                            }),
                        itemCount: details.sizes.length ?? 0,
                        itemBuilder: (context, index, pageViewIndex) {
                          var size = details.sizes[index];
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset("assets/${size.image}"),
                              Text(size.name)
                            ],
                          );
                        },
                      ),
                      _toppings("Vegetarian", details.toppings.vegetarian),
                      _toppings(
                          "non-Vegetarian", details.toppings.nonVegetarian),
                      Obx(() => CustomButton(
                              "Add to order ${controller.itemPrice}", () {
                            controller.menuItem.toppings
                                .addAll(controller.selectedNonVegToppings);
                            controller.menuItem.toppings
                                .addAll(controller.selectedVegToppings);
                            print(
                                "GOT ITEM FOR DATA: ${controller.menuItem.toString()}");
                            controller.cartController.menuItems
                                .add(controller.menuItem);
                            Get.back();
                            // controller.addItem(item);
                          }))
                    ],
                  ),
                );
              }))),
    );
  }

  Widget _toppings(String title, List<ToppingModel> toppings) {
    // if (details == null) return Container();
    // controller.vegSelected = List<bool>.filled(toppings.length, true);
    // controller.vegSelected = RxList<bool>.filled(toppings.length, false);
    return Wrap(
      children: [
        Text("Toppings - $title"),
        Obx(() => ToggleButtons(
              isSelected: title == "Vegetarian"
                  ? controller.vegSelected
                  : controller.nonVegSelected,
              onPressed: (index) {
                var selectedTopping = toppings[index];
                if (title == "Vegetarian") {
                  if (!controller.selectedVegToppings
                      .contains(selectedTopping)) {
                    controller.selectedVegToppings.add(selectedTopping);
                    controller.vegSelected[index] = true;
                    print("GOT LIST TRUE: ${controller.vegSelected}");
                    controller.addPrice(selectedTopping.price);
                  } else {
                    controller.selectedVegToppings.remove(selectedTopping);
                    controller.vegSelected[index] = false;
                    controller.removePrice(selectedTopping.price);
                    print("GOT LIST FALSE: ${controller.vegSelected}");
                  }
                } else if (title == "non-Vegetarian") {
                  if (!controller.selectedNonVegToppings
                      .contains(selectedTopping)) {
                    controller.selectedNonVegToppings.add(selectedTopping);
                    controller.nonVegSelected[index] = true;
                    print("GOT LIST TRUE: ${controller.nonVegSelected}");
                    controller.addPrice(selectedTopping.price);
                  } else {
                    controller.selectedNonVegToppings.remove(selectedTopping);
                    controller.nonVegSelected[index] = false;
                    controller.removePrice(selectedTopping.price);
                    print("GOT LIST FALSE: ${controller.nonVegSelected}");
                  }
                }
              },
              children: toppings
                  .map((topping) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(topping.name),
                      ))
                  .toList(),
            )),
      ],
    );
  }
}
