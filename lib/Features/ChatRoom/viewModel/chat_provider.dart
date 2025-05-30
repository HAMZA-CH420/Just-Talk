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
      //update for currentUser
      await _updateMessageForUser(
        currentUserId: currentUserId,
        otherUserId: otherUserId,
        lastMessage: msgText,
        senderOfLastMessage: currentUserId,
        incrementUnreadCount: false,
      );

      //update for otherUser
      await _updateMessageForUser(
          currentUserId: otherUserId,
          otherUserId: currentUserId,
          lastMessage: msgText,
          senderOfLastMessage: currentUserId,
          incrementUnreadCount: true);
    } on FirebaseException catch (e) {
      debugPrint(
          "Error sending message or updating last message: ${e.message}");
    }
  }

  //update Last message for both users
  Future<void> _updateMessageForUser({
    required String currentUserId,
    required String otherUserId,
    required String lastMessage,
    required String senderOfLastMessage,
    required bool incrementUnreadCount,
  }) async {
    try {
      DocumentReference chatEntryRef = fireStore
          .collection("userChats")
          .doc(currentUserId)
          .collection('chats')
          .doc(otherUserId);
      Map<String, dynamic> updateData = {
        'lastMessage': lastMessage.length > 50
            ? '${lastMessage.substring(0, 47)}...'
            : lastMessage,
        'senderOfLastMessage': senderOfLastMessage,
        'lastMessageTimeStamp': FieldValue.serverTimestamp(),
      };

      if (incrementUnreadCount) {
        updateData['unReadCount'] = FieldValue.increment(1);
      } else {
        updateData['unReadCount'] = 0;
      }

      await chatEntryRef.set(updateData, SetOptions(merge: true));
    } on FirebaseException catch (e) {
      debugPrint("error updating last message for both users: ${e.message}");
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
        .where("isRead", isEqualTo: false)
        .get();
    WriteBatch batch = fireStore.batch();
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
