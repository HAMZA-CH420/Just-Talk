import 'package:flutter/material.dart';
import 'package:just_talk/UiHelpers/Utils/Color_Palette/color_palette.dart';

class CredentialsTextField extends StatelessWidget {
  const CredentialsTextField(
      {super.key,
      required this.labelText,
      this.isPassword = false,
      required this.controller});
  final String labelText;
  final bool isPassword;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Material(
      elevation: .5,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: size.height / 15,
        width: size.width,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextField(
          obscureText: isPassword,
          controller: controller,
          decoration: InputDecoration(
            border: InputBorder.none,
            labelText: labelText,
            labelStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Palette.primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
