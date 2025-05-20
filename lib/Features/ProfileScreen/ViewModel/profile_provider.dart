import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileProvider with ChangeNotifier {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  //method to update username of loggedIn user
  Future<void> updateUsername(String username) async {
    try {
      await fireStore
          .collection("users")
          .doc(auth.currentUser!.displayName)
          .update({'name': username});
      auth.currentUser!.updateDisplayName(username);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //Method to update user's about
  Future<void> updateAbout(String about) async {
    try {
      await fireStore
          .collection("users")
          .doc(auth.currentUser!.displayName)
          .update({'about': about});
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
