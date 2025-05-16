import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:just_talk/Features/BottomNavBar/bottom_nav_bar.dart';
import 'package:just_talk/Features/LoginScreen/login_screen.dart';
import 'package:just_talk/UiHelpers/Utils/Color_Palette/color_palette.dart';
import 'package:just_talk/UiHelpers/Utils/Widgets/credentials_text_field.dart';
import 'package:just_talk/UiHelpers/Utils/Widgets/primary_button.dart';
import 'package:just_talk/UiHelpers/Utils/Widgets/secondary_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  spacing: 10,
                  children: [
                    SvgPicture.asset("assets/logo/just_talk.svg"),
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height / 10,
                    ),
                    CredentialsTextField(
                      labelText: "Username",
                      controller: usernameController,
                    ),
                    CredentialsTextField(
                      labelText: "Email Address",
                      controller: emailController,
                    ),
                    CredentialsTextField(
                      labelText: "Password",
                      controller: passwordController,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    PrimaryButton(
                      btnName: "SignUp",
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BottomNavBar(),
                            ));
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account?"),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ));
                          },
                          child: Text(
                            " LogIn",
                            style: TextStyle(
                              color: Palette.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SecondaryButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
