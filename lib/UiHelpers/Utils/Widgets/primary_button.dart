import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_talk/UiHelpers/Utils/Color_Palette/color_palette.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({super.key, required this.onTap, required this.btnName});
  final VoidCallback onTap;
  final String btnName;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: size.height / 15.5,
        width: size.width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Palette.primaryColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          btnName,
          style: GoogleFonts.publicSans(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
