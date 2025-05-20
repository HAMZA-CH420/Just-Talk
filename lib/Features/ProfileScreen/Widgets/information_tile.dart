import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_talk/UiHelpers/Utils/Color_Palette/color_palette.dart';

class InformationTile extends StatelessWidget {
  const InformationTile(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.icon,
      required this.isLoggedUser,
      required this.onTap});
  final String title, subtitle;
  final IconData icon;
  final bool isLoggedUser;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      minLeadingWidth: 35,
      leading: Icon(icon),
      title: Text(
        title,
        style: GoogleFonts.publicSans(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Palette.primaryColor),
      ),
      subtitle: Text(subtitle,
          style: GoogleFonts.publicSans(
            fontSize: 15,
          )),
      trailing: isLoggedUser
          ? GestureDetector(
              onTap: onTap,
              child: Icon(
                Icons.edit,
                color: Colors.black54,
              ),
            )
          : null,
    );
  }
}
