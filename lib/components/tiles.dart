import 'package:flutter/material.dart';

class Tiles extends StatelessWidget {
  final String imagePath;
  final Function()? onTap;
  const Tiles({super.key, required this.imagePath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.all(12), // Reduced padding for a more compact look
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey[200],
        ),
        child: Image.asset(
          imagePath,
          height: 40, // You can adjust this height if needed
          width: 40, // Ensure that the width is set to make it look consistent
        ),
      ),
    );
  }
}
