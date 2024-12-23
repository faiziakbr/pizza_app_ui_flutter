import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:get/get.dart';
import 'package:pizza_app_ui_flutter/models/topping_model.dart';
import 'package:pizza_app_ui_flutter/modules/selection/selection_controller.dart';
import 'package:pizza_app_ui_flutter/shared/widgets/MontserratText.dart';
import 'package:pizza_app_ui_flutter/shared/widgets/custom_button.dart';

class SelectionScreen extends GetView<SelectionController> {
  const SelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
        appBar: AppBar(
          title: MontserratText(
              controller.menuItemArg.name ?? "", 18, FontWeight.bold,
              textColor: Colors.black),
          actions: [
            IconButton(
                onPressed: () {
                  var result = controller.calculate();
                  if (!result.status) {
                    Get.snackbar(result.message, result.message);
                  } else {
                    controller.addToCart();
                    Get.back();
                  }
                },
                icon: const Icon(Icons.add))
          ],
        ),
        body: _promoFlavors(size)
        // body: controller.menuArg.category == "regular_flavors"
        //     ? _regularFlavors(size)
        //     : _promoFlavors(size),
        );
  }

  Widget _promoFlavors(Size size) {
    return SafeArea(
      child: Container(
          height: size.height,
          width: size.width,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: controller.obx((pizzaDetails) {
            if (pizzaDetails == null) return Container();
            // pizzaDetails.selected =
            //     RxList<bool>.filled(controller.menuItem.promo?.length, false);
            return ListView.separated(
              itemCount: controller.pizzaCount,
              itemBuilder: (context, index) {
                return Column(
                  spacing: 12,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Select option for pizza - ${index + 1}"),
                    Text("Select flavors for pizza - ${index + 1}"),
                    controller.menuArg.category == "promotional_items"
                        ? MultiSelectContainer(
                            singleSelectedItem: true,
                            items: pizzaDetails.flavors
                                .map(
                                  (flavors) => MultiSelectCard(
                                      value: flavors.name,
                                      child: _imageWithText(
                                          "assets/1.png", flavors.name)),
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
                                  // controller.menuItemArg.size = selectedSize;
                                  // controller.itemPrice.value =
                                  //     selectedSize.price;
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
                                  Text(size.name)
                                ],
                              );
                            },
                          ),
                    const Text("Toppings"),
                    _newToppings(
                        "Vegetable",
                        pizzaDetails.toppings.vegetarian,
                        controller.pizzas[index].maxToppings,
                        controller.pizzas[index].vegToppings),
                    _newToppings(
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

  Widget _regularFlavors(Size size) {
    return SafeArea(
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
                            // controller.menuItemArg.size = selectedSize;
                            // controller.itemPrice.value = selectedSize.price;
                            controller.pizzas[0].sizePrice = selectedSize.price;
                            controller.pizzas[0].size = selectedSize.name;
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
                    _newToppings(
                        "Vegetarian",
                        details.toppings.vegetarian,
                        details.toppings.vegetarian.length,
                        controller.pizzas[0].vegToppings),
                    _newToppings(
                        "non-Vegetarian",
                        details.toppings.nonVegetarian,
                        details.toppings.nonVegetarian.length,
                        controller.pizzas[0].nonBegToppings),
                    // _toppings("Vegetarian", details.toppings.vegetarian,
                    //     controller.vegSelected, controller.selectedVegToppings),
                    // _toppings(
                    //     "non-Vegetarian",
                    //     details.toppings.nonVegetarian,
                    //     controller.nonVegSelected,
                    //     controller.selectedNonVegToppings),
                    // Obx(() => CustomButton(
                    //         "Add to order ${controller.itemPrice.toStringAsFixed(1)}",
                    //         () {
                    //       // controller.menuItem.toppings
                    //       //     .addAll(controller.selectedNonVegToppings);
                    //       // controller.menuItem.toppings
                    //       //     .addAll(controller.selectedVegToppings);
                    //       // print(
                    //       //     "GOT ITEM FOR DATA: ${controller.menuItem.toString()}");
                    //       // controller.cartController.menuItems
                    //       //     .add(controller.menuItem);
                    //       // Get.back();
                    //     }))
                  ],
                ),
              );
            })));
  }

  Widget _imageWithText(String image, String text) {
    return SizedBox(
      width: 100,
      height: 100,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
              child: Image.asset(
            "assets/1.png",
            fit: BoxFit.contain,
          )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(text),
          )
        ],
      ),
    );
  }

  Widget _newToppings(String title, List<ToppingModel> toppings,
      int maxSelectedCount, List<ToppingModel> selectedToppings) {
    return Wrap(
      children: [
        Text("Toppings - $title"),
        MultiSelectContainer(
            items: toppings
                .map((topping) => MultiSelectCard(
                      child: Text(topping.name),
                      value: topping,
                    ))
                .toList(),
            maxSelectableCount: maxSelectedCount,
            onChange: (allSelectedItems, selectedItem) {
              // controller.pizzas[index].vegToppings = allSelectedItems;

              // selectedToppings = allSelectedItems;
              selectedToppings.clear();
              selectedToppings.addAll(allSelectedItems);
              // print("GOT ITEMS: ${allSelectedItems} and ${selectedToppings} and ${controller.pizzas[0].vegToppings}");
            })
      ],
    );
  }

  Widget _toppings(String title, List<ToppingModel> toppings,
      RxList<bool> selected, List<ToppingModel> selectedToppings) {
    // if (details == null) return Container();
    // controller.vegSelected = List<bool>.filled(toppings.length, true);
    // controller.vegSelected = RxList<bool>.filled(toppings.length, false);
    return Wrap(
      children: [
        Text("Toppings - $title"),
        Obx(() => ToggleButtons(
              isSelected: selected,
              onPressed: (index) {
                var selectedTopping = toppings[index];
                // if (title == "Vegetarian") {
                if (!selectedToppings.contains(selectedTopping)) {
                  selectedToppings.add(selectedTopping);
                  selected[index] = true;
                  // print("GOT LIST TRUE: ${controller.vegSelected}");
                  controller.addPrice(selectedTopping.price);
                } else {
                  selectedToppings.remove(selectedTopping);
                  selected[index] = false;
                  controller.removePrice(selectedTopping.price);
                  // print("GOT LIST FALSE: ${controller.vegSelected}");
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
