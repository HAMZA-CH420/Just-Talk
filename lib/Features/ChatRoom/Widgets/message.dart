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
      alignment: map["senderId"] == auth.currentUser!.uid
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 14),
        margin: const EdgeInsets.symmetric(vertical: 5),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width / 1.8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomLeft: map["senderId"] == auth.currentUser!.uid
                ? Radius.circular(15)
                : Radius.circular(0),
            bottomRight: map["senderId"] == auth.currentUser!.uid
                ? Radius.circular(0)
                : Radius.circular(15),
          ),
          color: map["senderId"] == auth.currentUser!.uid
              ? Colors.white
              : Palette.primaryColor,
        ),
        child: Text(
          map["msg"],
          style: GoogleFonts.publicSans(
              fontSize: 16,
              color: map["senderId"] == auth.currentUser!.uid
                  ? Palette.primaryColor
                  : Colors.white),
        ),
      ),
    );
  }
}
