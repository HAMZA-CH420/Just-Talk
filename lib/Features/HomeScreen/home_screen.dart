import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Inbox",
          style: GoogleFonts.publicSans(
            fontSize: 30,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Iconsax.notification,
              ))
        ],
      ),
      body: Container(),
    );
  }
}
