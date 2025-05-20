import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Center(
        child: IconButton(
            onPressed: () async => await FirebaseAuth.instance.signOut(),
            icon: Icon(Iconsax.logout)),
      ),
    );
  }
}
