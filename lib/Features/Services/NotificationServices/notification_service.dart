import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

class NotificationServices {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  //check for potential permission
  Future<void> notificationSettings() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint("Permission Granted by user");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      debugPrint("User granted provisional permission");
    } else {
      debugPrint("Permission denied by user");
    }
  }

  //initialize messaging
  Future<void> initNotifications() async {
    final String? token = await _firebaseMessaging.getToken();
    debugPrint("fcm:$token");
    if (token != null && _auth.currentUser != null) {
      await saveTokenToDataBase(token);
    }
    _firebaseMessaging.onTokenRefresh.listen(saveTokenToDataBase);
  }

  //method to add token in firebase collection
  Future<void> saveTokenToDataBase(String token) async {
    final userId = _auth.currentUser!.uid;
    try {
      await _fireStore.collection('users').doc(userId).update({
        'fcmToken': FieldValue.arrayUnion([token]),
        'lastTokenUpdate': FieldValue.serverTimestamp()
      });
    } catch (e) {
      debugPrint("error while adding fcm token $e");
    }
  }

  //method to remove token from firebase collection
  Future<void> removeTokenFromDatabase() async {
    final userId = _auth.currentUser!.uid;
    final String? token = await _firebaseMessaging.getToken();
    try {
      await _fireStore.collection('users').doc(userId).update({
        'fcmToken': FieldValue.arrayRemove([token]),
      });
    } catch (e) {
      debugPrint("error while removing fcm token $e");
    }
  }
}
