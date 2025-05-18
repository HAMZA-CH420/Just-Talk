import 'package:flutter/material.dart';

class NewChatProvider with ChangeNotifier {
  late Map<String, dynamic> _myChats;
  Map<String, dynamic> get myChats => _myChats;
  //method to add new chat in home screen
  addChatToHomeScreen(String keys, dynamic value) {
    _myChats[keys] = value;
    notifyListeners();
  }
}
