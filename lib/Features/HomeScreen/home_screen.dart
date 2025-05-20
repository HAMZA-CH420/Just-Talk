import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_talk/Features/AddNewChat/add_new_chat.dart';
import 'package:just_talk/Features/ChatRoom/viewModel/chat_provider.dart';
import 'package:just_talk/Features/HomeScreen/Widgets/my_chats.dart';
import 'package:just_talk/Features/HomeScreen/Widgets/search_bar.dart';
import 'package:just_talk/Features/ProfileScreen/profile_screen.dart';
import 'package:just_talk/UiHelpers/Utils/Color_Palette/color_palette.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<ChatProvider>().updateUserStatus("online");
    }
    if (state == AppLifecycleState.detached) {
      context.read<ChatProvider>().updateUserStatus("Offline");
    }
    if (state == AppLifecycleState.inactive) {
      context.read<ChatProvider>().updateUserStatus("Offline");
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddNewChat(),
                ));
          },
          backgroundColor: Palette.primaryColor,
          shape: CircleBorder(),
          elevation: 2,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        appBar: AppBar(
          scrolledUnderElevation: 0.0,
          elevation: 0,
          backgroundColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          title: Text(
            "Inbox",
            style: GoogleFonts.publicSans(
              fontSize: 30,
              fontWeight: FontWeight.w400,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                        userId: auth.currentUser!.displayName ?? "Default",
                      ),
                    )),
                child: CircleAvatar(
                  radius: 22,
                  backgroundColor: Palette.secondaryColor,
                  child: Icon(
                    CupertinoIcons.person_alt,
                    color: Palette.primaryColor,
                  ),
                ),
              ),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            spacing: 10,
            children: [
              CustomSearchBar(),
              Expanded(child: MyChats()),
            ],
          ),
        ),
      ),
    );
  }
}
