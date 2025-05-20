import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_talk/Features/ProfileScreen/Widgets/information_tile.dart';
import 'package:just_talk/UiHelpers/Utils/Color_Palette/color_palette.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          spacing: 18,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: 85,
                backgroundColor: Palette.primaryColor,
                child: Icon(
                  CupertinoIcons.person,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ),
            Column(
              children: [
                InformationTile(
                  title: "Name",
                  subtitle: "Hamza Ch",
                  icon: CupertinoIcons.person,
                ),
                InformationTile(
                  title: "About",
                  subtitle: "Hi! im' using just talk",
                  icon: Icons.info_outline,
                ),
                InformationTile(
                  title: "Email Address",
                  subtitle: "hamza@gmail.com",
                  icon: Icons.email_outlined,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
