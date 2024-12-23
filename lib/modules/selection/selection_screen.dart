import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pizza_app_ui_flutter/models/topping_model.dart';
import 'package:pizza_app_ui_flutter/modules/selection/selection_controller.dart';
import 'package:pizza_app_ui_flutter/shared/extensions/custom_snackbar.dart';
import 'package:pizza_app_ui_flutter/shared/widgets/MontserratText.dart';

class SelectionScreen extends GetView<SelectionController> {
  const SelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.yellow,
          title: MontserratText(
              controller.menuItemArg.name ?? "", 18, FontWeight.bold,
              textColor: Colors.black),
          actions: [
            IconButton(
                onPressed: () {
                  var result = controller.calculate();
                  if (!result.status) {
                    Get.customSnackbar("OOPS!", result.message, error: true);
                  } else {
                    Fluttertoast.showToast(
                        msg: "Item successfully added",
                        backgroundColor: Colors.yellow,
                        gravity: ToastGravity.BOTTOM);
                    controller.addToCart();
                    Get.back();
                  }
                },
                icon: const Icon(Icons.add_shopping_cart_sharp))
          ],
        ),
        body: _body(size));
  }

  Widget _body(Size size) {
    return SafeArea(
      child: SizedBox(
          height: size.height,
          width: size.width,
          child: controller.obx((pizzaDetails) {
            if (pizzaDetails == null) return Container();
            return ListView.separated(
              itemCount: controller.pizzaCount,
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: 12,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Select options for pizza - ${index + 1}"),
                    // Text("Select flavors for pizza - ${index + 1}"),
                    controller.menuArg.category == "promotional_items"
                        ? MultiSelectContainer(
                            singleSelectedItem: true,
                            items: pizzaDetails.flavors
                                .map(
                                  (flavors) => MultiSelectCard(
                                      highlightColor: Colors.yellow,
                                      splashColor: Colors.yellow,
                                      decorations: MultiSelectItemDecorations(
                                          selectedDecoration: BoxDecoration(
                                              color: Colors.yellow,
                                              borderRadius:
                                                  BorderRadius.circular(15))),
                                      value: flavors.name,
                                      child: _imageWithText(
                                          flavors.image, flavors.name)),
                                )
                                .toList(),
                            onMaximumSelected:
                                (allSelectedItems, selectedItem) {
                              Get.snackbar("Limit reached",
                                  'The limit has been reached');
                            },
                            onChange: (allSelectedItems, selectedItem) {
                              controller.pizzas[index].name = selectedItem;
                            },
                          )
                        : CarouselSlider.builder(
                            options: CarouselOptions(
                                enableInfiniteScroll: false,
                                initialPage: 0,
                                animateToClosest: true,
                                height: size.height * 0.4,
                                onPageChanged: (index, reason) {
                                  var selectedSize = pizzaDetails.sizes[index];
                                  controller.pizzas[0].size = selectedSize.name;
                                }),
                            // itemCount: details.sizes.length ?? 0,
                            itemCount: pizzaDetails.sizes.length ?? 0,
                            itemBuilder: (context, index, pageViewIndex) {
                              var size = pizzaDetails.sizes[index];
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset("assets/${size.image}"),
                                  MontserratText("Size - ${size.name}", 16,
                                      FontWeight.bold)
                                ],
                              );
                            },
                          ),
                    _toppings(
                        "Vegetable",
                        pizzaDetails.toppings.vegetarian,
                        controller.pizzas[index].maxToppings,
                        controller.pizzas[index].vegToppings),
                    const SizedBox(height: 10),
                    _toppings(
                        "non-Vegetable",
                        pizzaDetails.toppings.nonVegetarian,
                        controller.pizzas[index].maxToppings,
                        controller.pizzas[index].nonBegToppings),
                  ],
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Container(
                  width: size.width * 0.9,
                  height: 10,
                  color: Colors.black,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                );
              },
            );
          })),
    );
  }

  Widget _toppings(String title, List<ToppingModel> toppings,
      int maxSelectedCount, List<ToppingModel> selectedToppings) {
    return Wrap(
      children: [
        MontserratText("Toppings - $title", 16, FontWeight.bold),
        MultiSelectContainer(
            items: toppings
                .map((topping) => MultiSelectCard(
                      highlightColor: Colors.yellow,
                      splashColor: Colors.yellow,
                      decorations: MultiSelectItemDecorations(
                          selectedDecoration: BoxDecoration(
                              color: Colors.yellow,
                              borderRadius: BorderRadius.circular(15))),
                      child: _imageWithText(topping.image, topping.name),
                      value: topping,
                    ))
                .toList(),
            maxSelectableCount: maxSelectedCount,
            onChange: (allSelectedItems, selectedItem) {
              selectedToppings.clear();
              selectedToppings.addAll(allSelectedItems);
            })
      ],
    );
  }

  Widget _imageWithText(String? image, String text) {
    return SizedBox(
      height: 200,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          (image != null)
              ? Expanded(
                  child: Image.asset(
                  "assets/$image",
                  fit: BoxFit.fill,
                ))
              : Container(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(text),
          )
        ],
      ),
    );
  }
}
