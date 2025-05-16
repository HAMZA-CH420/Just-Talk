import 'package:flutter/material.dart';
import 'package:just_talk/UiHelpers/Utils/Color_Palette/color_palette.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Container(
      width: size.width,
      height: size.height / 16,
      padding: EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Palette.secondaryColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.search,
            color: Palette.primaryColor,
            size: 27,
          ),
          hintText: "Search...",
          hintStyle: TextStyle(
            fontSize: 18,
            color: Palette.primaryColor,
          ),
        ),
      ),
    );
  }
}
