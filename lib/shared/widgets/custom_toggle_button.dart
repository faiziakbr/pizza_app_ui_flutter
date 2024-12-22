
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomToggleButtonController extends GetxController {
  // Reactive variable for button color
  var buttonColor = Colors.blue.obs;

  void changeColor() {
    buttonColor.value = Colors.yellow; // Change color to yellow
  }
}

class CustomToggleButton extends StatelessWidget {
  final String text;
  final String imagePath;
  final VoidCallback onPressed;

  CustomToggleButton({
    required this.text,
    required this.imagePath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final CustomToggleButtonController controller = Get.put(CustomToggleButtonController());

    return Obx(
          () => GestureDetector(
        onTap: () {
          controller.changeColor(); // Change color via controller
          onPressed(); // Trigger the callback
        },
        child: Container(
          decoration: BoxDecoration(
            color: controller.buttonColor.value,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  imagePath,
                  width: 40,
                  height: 40,
                ),
                SizedBox(height: 8),
                Text(
                  text,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}