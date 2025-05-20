import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_talk/UiHelpers/Utils/Color_Palette/color_palette.dart';

class InformationTile extends StatelessWidget {
  const InformationTile(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.icon});
  final String title, subtitle;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      minLeadingWidth: 35,
      leading: Icon(icon),
      title: Text(
        title,
        style: GoogleFonts.publicSans(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Palette.primaryColor),
      ),
      subtitle: Text(subtitle),
    );
  }
}
