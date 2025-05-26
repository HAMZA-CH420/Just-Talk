import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatProvider with ChangeNotifier {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  /// Method to create chatroom Ids
  String chatRoomId(String? user1, String? user2) {
    if (user1 != null &&
        user2 != null &&
        user1.isNotEmpty &&
        user2.isNotEmpty) {
      if (user1.compareTo(user2) > 0) {
        return "$user1$user2";
      } else {
        return "$user2$user1";
      }
    } else {
      return "";
    }
  }

  ///method to update user status based on app life cycle
  Future<void> updateUserStatus({required String status}) async {
    try {
      await fireStore
          .collection("users")
          .doc(auth.currentUser!.uid)
          .update({'status': status});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //send message method
  Future<void> sendMessage({
    required String currentUserId,
    required String otherUserId,
    required String msgText,
    required String chatRoomId,
  }) async {
    if (msgText.trim().isEmpty) return;
    try {
      DocumentReference messageDocRef = fireStore
          .collection("chatRoom")
          .doc(chatRoomId)
          .collection('messages')
          .doc();
      await messageDocRef.set({
        "senderId": currentUserId,
        "receiverId": otherUserId,
        "msgText": msgText,
        "isRead": false,
        "timeStamp": FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      debugPrint(
          "Error sending message or updating last message: ${e.message}");
    }
  }
}
