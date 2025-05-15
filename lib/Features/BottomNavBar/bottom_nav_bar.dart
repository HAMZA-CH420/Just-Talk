import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_talk/Features/HomeScreen/home_screen.dart';
import 'package:just_talk/Features/ProfileScreen/profile_screen.dart';
import 'package:just_talk/UiHelpers/Utils/Color_Palette/color_palette.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    HomeScreen(),
    ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        color: Palette.primaryColor,
        backgroundColor: Colors.transparent,
        animationDuration: Duration(milliseconds: 400),
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
        items: [
          Icon(
            Icons.home_filled,
            color: Colors.white,
            size: 30,
          ),
          Icon(
            Icons.settings,
            color: Colors.white,
            size: 30,
          ),
        ],
      ),
    );
  }
}
