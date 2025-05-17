import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_talk/UiHelpers/Utils/Color_Palette/color_palette.dart';

class CredentialsTextField extends StatefulWidget {
  const CredentialsTextField(
      {super.key,
      required this.labelText,
      this.isPassword = false,
      required this.controller,
      required this.validator});
  final String labelText;
  final bool isPassword;
  final TextEditingController controller;
  final FormFieldValidator validator;

  @override
  State<CredentialsTextField> createState() => _CredentialsTextFieldState();
}

class _CredentialsTextFieldState extends State<CredentialsTextField> {
  bool showPass = true;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Container(
      width: size.width,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey.shade500,
        ),
      ),
      child: TextFormField(
        validator: widget.validator,
        obscureText: widget.isPassword ? showPass : false,
        controller: widget.controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: widget.labelText,
          labelStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Palette.primaryColor,
          ),
          suffixIcon: widget.isPassword
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      showPass = !showPass;
                    });
                  },
                  icon: Icon(
                    showPass
                        ? Icons.remove_red_eye
                        : CupertinoIcons.eye_slash_fill,
                    color: Colors.black38,
                    size: 28,
                  ))
              : null,
        ),
      ),
    );
  }
}
