import 'package:chat_app_ayna/constats.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  Widget widget;
  VoidCallback onPressed;
  CustomButton({super.key, required this.widget, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            // gradient: const LinearGradient(
            //   colors: [
            //     Color.fromARGB(255, 34, 103, 160),
            //     Color.fromARGB(255, 224, 95, 138)
            //   ],
            // ),
            color:themeColor
            ),
        child: Center(child: widget),
      ),
    );
  }
}
