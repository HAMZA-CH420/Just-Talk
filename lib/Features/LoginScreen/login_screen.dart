import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:just_talk/Features/SignUpScreen/sign_up_screen.dart';
import 'package:just_talk/UiHelpers/Utils/Color_Palette/color_palette.dart';
import 'package:just_talk/UiHelpers/Utils/Widgets/credentials_text_field.dart';
import 'package:just_talk/UiHelpers/Utils/Widgets/primary_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 10,
              children: [
                SvgPicture.asset("assets/logo/just_talk.svg"),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height / 10,
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
                  btnName: "Login",
                  onTap: () {},
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?"),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUpScreen(),
                            ));
                      },
                      child: Text(
                        " SignUp",
                        style: TextStyle(
                          color: Palette.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
