import 'package:flutter/material.dart';
import 'package:just_talk/Features/HomeScreen/Widgets/all_chats.dart';
import 'package:just_talk/Features/HomeScreen/Widgets/search_bar.dart';

class AddNewChat extends StatelessWidget {
  const AddNewChat({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomSearchBar(),
            Expanded(child: AllChats()),
          ],
        ),
      ),
    );
  }
}
