import 'package:flutter/material.dart';
import 'package:just_talk/Features/AddNewChat/Widgets/all_chats.dart';
import 'package:just_talk/Features/HomeScreen/Widgets/search_bar.dart';

class AddNewChat extends StatelessWidget {
  const AddNewChat({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            spacing: 20,
            children: [
              CustomSearchBar(),
              Expanded(child: AllChats()),
            ],
          ),
        ),
      ),
    );
  }
}
