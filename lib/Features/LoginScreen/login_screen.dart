import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:just_talk/Features/Services/AuthServices/auth_services.dart';
import 'package:just_talk/Features/SignUpScreen/sign_up_screen.dart';
import 'package:just_talk/Features/ViewModel/Validator/validator.dart';
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
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    FocusManager.instance.primaryFocus!.unfocus();
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
            child: Form(
              key: _formKey,
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
                    validator: (value) => Validator.emailValidator(value),
                  ),
                  CredentialsTextField(
                    labelText: "Password",
                    controller: passwordController,
                    isPassword: true,
                    validator: (value) => Validator.passwordValidator(value),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  PrimaryButton(
                    btnName: "Login",
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          await AuthServices().loginUserWithCredentials(
                              emailController.text.trim(),
                              passwordController.text.trim());
                        } on FirebaseAuthException {
                          debugPrint("Error");
                        }
                      }
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account?"),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
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
      ),
    );
  }
}
