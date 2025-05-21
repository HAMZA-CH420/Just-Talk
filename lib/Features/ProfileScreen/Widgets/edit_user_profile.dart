import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_talk/Features/ProfileScreen/ViewModel/profile_provider.dart';
import 'package:just_talk/UiHelpers/Utils/Color_Palette/color_palette.dart';
import 'package:provider/provider.dart';

class EditUserProfile extends StatefulWidget {
  const EditUserProfile(
      {super.key, required this.label, required this.controllerValue});
  final String label;
  final String controllerValue;
  @override
  State<EditUserProfile> createState() => _EditUserProfileState();
}

class _EditUserProfileState extends State<EditUserProfile> {
  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    controller.text = widget.controllerValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.label),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                spacing: 10,
                children: [
                  TextField(
                    controller: controller,
                    autofocus: true,
                    decoration: InputDecoration(
                      label: Text("Your ${widget.label}"),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Palette.primaryColor,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Palette.primaryColor,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(7)),
                    ),
                  ),
                  Text("People will see this name if you interact with them.")
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                if (widget.label == "Name") {
                  context
                      .read<ProfileProvider>()
                      .updateUsername(controller.text.toString());
                  Navigator.pop(context);
                } else if (widget.label == "About") {
                  context
                      .read<ProfileProvider>()
                      .updateAbout(controller.text.toString());
                  Navigator.pop(context);
                }
              },
              child: Container(
                height: 45,
                width: MediaQuery.sizeOf(context).width / 1.2,
                margin: const EdgeInsets.symmetric(vertical: 5),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Palette.primaryColor,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Text(
                  "Save",
                  style: GoogleFonts.publicSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
