import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pizza_app_ui_flutter/models/menu_model.dart';
import 'package:pizza_app_ui_flutter/modules/home/home_controller.dart';
import 'package:pizza_app_ui_flutter/routes/app_pages.dart';
import 'package:pizza_app_ui_flutter/shared/widgets/MontserratText.dart';
import 'package:pizza_app_ui_flutter/shared/widgets/custom_button.dart';
import 'package:pizza_app_ui_flutter/shared/widgets/custom_toggle_button.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Container(
          width: size.width,
          height: size.height,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: controller.obx((pizzaMenu) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 60,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: pizzaMenu?.menus.length ?? 0,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            child: Chip(
                              label: Text(pizzaMenu?.menus[index].title ?? ""),
                              backgroundColor:
                                  Colors.blueAccent.withOpacity(0.2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          );
                        }),
                  ),
                  SizedBox(
                    height: size.height * 0.7,
                    child: ListView.builder(
                        itemCount: pizzaMenu?.menus.length,
                        itemBuilder: (context, index) {
                          final menu = pizzaMenu?.menus[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Category Title
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  menu?.title ?? "",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              // Horizontal ListView of Items
                              SizedBox(
                                height: 250,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: menu?.items.length,
                                  itemBuilder: (context, itemIndex) {
                                    final item = menu?.items[itemIndex];
                                    return Card(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Container(
                                        width: 200,
                                        padding: EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Image.asset("assets/${item?.image}",
                                                height: 140),
                                            Text(
                                              item?.name ?? "",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  Get.toNamed(Routes.SELECTION,
                                                      arguments: {
                                                        "menu": menu,
                                                        "item": item
                                                      });
                                                },
                                                icon: Icon(Icons.add))
                                            // CustomButton("Add", () {
                                            //   if (item == null ||
                                            //       menu == null) {
                                            //     return;
                                            //   }
                                            //   Get.toNamed(Routes.SELECTION,
                                            //       arguments: {
                                            //         "menu": menu,
                                            //         "item": item
                                            //       });
                                            // })
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        }),
                  ),
                ],
              ),
            );
          },
              onLoading: const Center(child: CircularProgressIndicator()),
              onError: (error) =>
                  ElevatedButton(onPressed: () {}, child: Text("reload"))),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(Routes.CART);
        },
        child: Obx(
            () => Text("cart ${controller.cartController.menuItems.length}")),
      ),
    );
  }

  Widget _bottomSheet(Menu menu, MenuItem menuItem, Size size) {
    print("GOT ITEM: ${menuItem.toString()} and ${menu.category}");
    var details = controller.pizzaDetail.value;
    if (details == null) return Container();

    // for (int i = 0; i < menuItem.pizzaCount!; i++) {}
    menuItem.size = details.sizes[0];

    return _pizzaDetailSelection(menu, menuItem, size);
    // return Container(
    //   height: size.height * 0.9,
    //   margin: const EdgeInsets.only(top: 16),
    //   child: Column(
    //     children: [
    //       Expanded(
    //         child: ListView.builder(
    //             itemCount: menuItem.pizzaCount ?? 1,
    //             itemBuilder: (context, index) {
    //               return _pizzaDetailSelection(menu, menuItem, size);
    //             }),
    //       ),
    //       Flexible(
    //           child: CustomButton("Add to order", () {
    //         print("GOT ITEM FOR DATA: ${menuItem.toString()}");
    //         // controller.addItem(item);
    //       }))
    //     ],
    //   ),
    // );
  }

  Widget _pizzaDetailSelection(Menu menu, MenuItem menuItem, Size size) {
    var details = controller.pizzaDetail.value;
    if (details == null) return Container();

    return SizedBox(
      height: size.height * 0.8,
      child: Column(
        children: [
          CarouselSlider.builder(
            options: CarouselOptions(
                initialPage: 0,
                animateToClosest: true,
                height: size.height * 0.4,
                onPageChanged: (index, reason) {
                  var selectedSize = details.sizes[index];
                  menuItem.size = selectedSize;
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
          Text("Toppings - Vegetarian"),
          Wrap(
            spacing: 10.0, // Space between items horizontally
            runSpacing: 10.0, // Space between items vertically
            children: details.toppings.vegetarian.map((item) {
              return GestureDetector(
                onTap: () {
                  if (!menuItem.toppings.contains(item)) {
                    menuItem.toppings.add(item);
                  } else {
                    menuItem.toppings.remove(item);
                  }
                },
                child: Container(
                  width: 80,
                  height: 80,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: menuItem.toppings.contains(item)
                        ? Colors.blue
                        : Colors.yellow,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    item.name,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              );
            }).toList(),
          ),
          Text("Toppings - non-Vegetarian"),
          Wrap(
            spacing: 10.0, // Space between items horizontally
            runSpacing: 10.0, // Space between items vertically
            children: details.toppings.nonVegetarian.map((item) {
              return GestureDetector(
                onTap: () {
                  if (!menuItem.toppings.contains(item)) {
                    menuItem.toppings.add(item);
                  } else {
                    menuItem.toppings.remove(item);
                  }
                },
                child: Container(
                  width: 80,
                  // Fixed width for each item
                  height: 80,
                  // Fixed height for each item
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    item.name,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              );
            }).toList(),
          ),
          Flexible(
              child: CustomButton("Add to order", () {
            print("GOT ITEM FOR DATA: ${menuItem.toString()}");
            // controller.addItem(item);
          }))
        ],
      ),
    );
  }
}
