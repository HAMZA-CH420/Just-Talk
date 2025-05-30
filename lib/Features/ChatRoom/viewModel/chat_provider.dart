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
    required String otherUserName,
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
        "msg": msgText,
        "isRead": false,
        "timeStamp": FieldValue.serverTimestamp(),
      });
      //update myChatList for sender
      DocumentReference senderChatListRef = fireStore
          .collection("userChats")
          .doc(currentUserId)
          .collection("chats")
          .doc(otherUserId);
      await senderChatListRef.set({
        "lastMessage":
            msgText.length > 50 ? '${msgText.substring(0, 47)}...' : msgText,
        "lastMessageTimeStamp": FieldValue.serverTimestamp(),
        'senderOfLastMessage': currentUserId,
        "name": otherUserName,
        "uid": otherUserId,
        'unReadCount': 0,
      }, SetOptions(merge: true));

      //update myChats List for receiver
      DocumentReference receiverChatListRef = fireStore
          .collection("userChats")
          .doc(otherUserId)
          .collection("chats")
          .doc(currentUserId);

      await receiverChatListRef.set({
        "lastMessage":
            msgText.length > 50 ? '${msgText.substring(0, 47)}...' : msgText,
        "lastMessageTimeStamp": FieldValue.serverTimestamp(),
        'senderOfLastMessage': currentUserId,
        "name": auth.currentUser!.displayName,
        "uid": currentUserId,
        'unReadCount': FieldValue.increment(1),
      }, SetOptions(merge: true));
    } on FirebaseException catch (e) {
      debugPrint(
          "Error sending message or updating last message: ${e.message}");
    }
  }

//method to mark messages read
  Future<void> markMessagesAsReadAndResetUnreadCount({
    required String chatRoomId,
    required String currentUserId,
    required String otherUserId,
  }) async {
    QuerySnapshot messageToUpdate = await fireStore
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("messages")
        .where("senderId", isEqualTo: otherUserId)
        .where("receiverId", isEqualTo: currentUserId)
        .where("isRead", isEqualTo: false)
        .get();
    if (messageToUpdate.docs.isEmpty) {
      DocumentReference currentUserChatEntry = fireStore
          .collection("userChats")
          .doc(currentUserId)
          .collection("chats")
          .doc(otherUserId);
      await currentUserChatEntry
          .set({'unReadCount': 0}, SetOptions(merge: true));
      return;
    }
    WriteBatch batch = fireStore.batch();
    if (messageToUpdate.docs.isNotEmpty) {
      for (DocumentSnapshot doc in messageToUpdate.docs) {
        batch.update(doc.reference, {"isRead": true});
        DocumentReference currentUserChatEntry = fireStore
            .collection("userChats")
            .doc(currentUserId)
            .collection("chats")
            .doc(otherUserId);
        batch.update(currentUserChatEntry, {'unReadCount': 0});
        await batch.commit();
      }
    }
  }
}
