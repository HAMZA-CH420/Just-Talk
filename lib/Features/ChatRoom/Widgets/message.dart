import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_talk/UiHelpers/Utils/Color_Palette/color_palette.dart';

class Message extends StatelessWidget {
  Message({super.key, required this.map});
  final Map<String, dynamic> map;
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: map["sentBy"] == auth.currentUser!.displayName
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomLeft: map["sentBy"] == auth.currentUser!.displayName
                ? Radius.circular(15)
                : Radius.circular(0),
            bottomRight: map["sentBy"] == auth.currentUser!.displayName
                ? Radius.circular(15)
                : Radius.circular(0),
          ),
          color: map["sentBy"] == auth.currentUser!.displayName
              ? Colors.white
              : Palette.primaryColor,
        ),
        child: Text(
          map["message"],
          style: GoogleFonts.publicSans(
              fontSize: 16,
              color: map["sentBy"] == auth.currentUser!.displayName
                  ? Palette.primaryColor
                  : Colors.white),
        ),
      ),
    );
  }
}
