import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_talk/Features/AuthenticationScreens/LoginScreen/login_screen.dart';
import 'package:just_talk/Features/HomeScreen/home_screen.dart';
import 'package:just_talk/UiHelpers/Utils/Color_Palette/color_palette.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        Future.delayed(Duration(milliseconds: 800), () {
          loginInfo();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SvgPicture.asset("assets/logo/just_talk.svg"),
      ),
    );
  }

  Future loginInfo() async {
    return Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) {
        return StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Palette.primaryColor,
                ),
              );
            } else if (snapshot.data != null) {
              return HomeScreen();
            } else {
              return LoginScreen();
            }
          },
        );
      },
    ));
  }
}
