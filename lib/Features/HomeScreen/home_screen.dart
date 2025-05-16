import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:just_talk/Features/HomeScreen/Widgets/search_bar.dart';
import 'package:just_talk/UiHelpers/Utils/Color_Palette/color_palette.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Palette.primaryColor,
        shape: CircleBorder(),
        elevation: 2,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          children: [
            CustomSearchBar(),
          ],
        ),
      ),
    );
  }
}
