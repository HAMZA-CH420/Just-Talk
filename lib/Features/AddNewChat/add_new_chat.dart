import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_talk/Features/AddNewChat/Widgets/all_chats.dart';
import 'package:just_talk/Features/HomeScreen/Widgets/search_bar.dart';

class AddNewChat extends StatefulWidget {
  const AddNewChat({super.key});

  @override
  State<AddNewChat> createState() => _AddNewChatState();
}

class _AddNewChatState extends State<AddNewChat> {
  String searchQuery = '';
  Timer? debounce;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            spacing: 20,
            children: [
              CustomSearchBar(
                onChanged: _handleSearchChanged,
              ),
              Expanded(
                  child: AllChats(
                searchQuery: searchQuery,
              )),
            ],
          ),
        ),
      ),
    );
  }

  //method to handle search changed

  void _handleSearchChanged(String query) {
    if (debounce?.isActive ?? false) debounce?.cancel();
    debounce = Timer(
      Duration(milliseconds: 300),
      () {
        if (mounted) {
          setState(() {
            searchQuery = query.toLowerCase();
          });
        }
      },
    );
  }
}
