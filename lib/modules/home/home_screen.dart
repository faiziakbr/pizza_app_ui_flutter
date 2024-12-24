import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pizza_app_ui_flutter/models/menu_model.dart';
import 'package:pizza_app_ui_flutter/modules/home/home_controller.dart';
import 'package:pizza_app_ui_flutter/routes/app_pages.dart';
import 'package:pizza_app_ui_flutter/shared/widgets/MontserratText.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
          title: Image.asset(
        "assets/logo.png",
        fit: BoxFit.fill,
      )),
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
                                child: MontserratText(
                                    menu?.title ?? "", 18, FontWeight.bold),
                              ),
                              // Horizontal ListView of Items
                              SizedBox(
                                height: 250,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: menu?.items.length,
                                  itemBuilder: (context, itemIndex) {
                                    final item = menu?.items[itemIndex];
                                    return GestureDetector(
                                      onTap: () {
                                        _goToSelectionSreen(
                                            menu, item);
                                      },
                                      child: Card(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Container(
                                          width: 200,
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            spacing: 16,
                                            children: [
                                              Flexible(
                                                flex: 5,
                                                child: Image.asset(
                                                  "assets/${item?.image}",
                                                ),
                                              ),
                                              Flexible(
                                                flex: 2,
                                                child: MontserratText(
                                                    item?.name ?? "",
                                                    16,
                                                    FontWeight.bold,
                                                    maxLines: 2),
                                              ),
                                              Flexible(
                                                flex: 1,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    if (item?.price != null)
                                                      Flexible(
                                                        child: MontserratText(
                                                          "\$${item?.price?.toStringAsFixed(1) ?? ""}",
                                                          16,
                                                          FontWeight.bold,
                                                          textColor: Colors.red,
                                                          maxLines: 1,
                                                        ),
                                                      )
                                                    else if (item?.discount !=
                                                        null)
                                                      Flexible(
                                                        child: MontserratText(
                                                          "${item?.discount ?? ""}% discount",
                                                          16,
                                                          FontWeight.bold,
                                                          textColor: Colors.red,
                                                          maxLines: 1,
                                                        ),
                                                      )
                                                    else
                                                      Container(),
                                                    const Flexible(
                                                      child: CircleAvatar(
                                                        backgroundColor:
                                                            Colors.yellow,
                                                        child: Icon(Icons.add),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
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
              onError: (error) => Center(
                child: ElevatedButton(
                    onPressed: () {
                      controller.loadData();
                    }, child: const Text("Reload")),
              )),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (controller.cartController.orderCount() > 0) {
            Get.toNamed(Routes.CART);
          } else {
            Fluttertoast.showToast(
                msg: "Cart is empty!",
                textColor: Colors.black,
                backgroundColor: Colors.yellow,
                gravity: ToastGravity.BOTTOM);
          }
        },
        backgroundColor: Colors.yellow,
        label: Obx(() => MontserratText(
            "Cart \$${controller.cartController.orderTotal()?.toStringAsFixed(1) ?? 0.0}",
            16,
            FontWeight.bold)),
      ),
    );
  }

  void _goToSelectionSreen(Menu? menu, MenuItem? item) {
    if (menu?.category == "promotional_items" ||
        menu?.category == "regular_flavors") {
      Get.toNamed(Routes.SELECTION, arguments: {"menu": menu, "item": item});
    } else {
      Fluttertoast.showToast(
          msg: "Sorry! We are all out!",
          textColor: Colors.black,
          backgroundColor: Colors.yellow,
          gravity: ToastGravity.BOTTOM);
    }
  }
}
