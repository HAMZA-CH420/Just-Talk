import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthServices {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  ///Method to Login User
  Future<void> loginUserWithCredentials(var email, var password) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return showToast("Login Successful", Colors.green);
    } on FirebaseAuthException {
      return showToast("Incorrect Email or Password", Colors.red);
    }
  }

  ///Method to create a user using email
  Future<void> createUserWithEmail(
      var email, var password, var username) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      await firebaseAuth.currentUser!.updateDisplayName(username);
      await fireStore.collection("users").doc(username).set({
        "name": username,
        "status": "unavailable",
        "uid": firebaseAuth.currentUser?.uid,
        "about": "Hey there! i am using JustTalk",
        "email": email,
        "time": FieldValue.serverTimestamp(),
      });
      return showToast("User Created Successfully", Colors.green);
    } on FirebaseAuthException {
      return showToast("User Already Exists", Colors.red);
    }
  }

  void showToast(String msg, Color bgColor) {
    Fluttertoast.showToast(
      msg: msg,
      backgroundColor: bgColor,
    );
  }
}
