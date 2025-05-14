import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_talk/UiHelpers/Utils/Color_Palette/color_palette.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({super.key});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Container(
      height: size.height / 15.5,
      width: size.width,
      margin: const EdgeInsets.symmetric(vertical: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          width: 1.5,
          color: Palette.primaryColor,
        ),
      ),
      child: Row(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset("assets/logo/google_logo.svg"),
          Text(
            "Continue with Google",
            style: GoogleFonts.publicSans(
              fontWeight: FontWeight.w500,
              fontSize: 17,
              color: Palette.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
