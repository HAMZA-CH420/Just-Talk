import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_talk/Features/ChatRoom/Widgets/message.dart';
import 'package:just_talk/Features/ChatRoom/Widgets/message_input.dart';
import 'package:just_talk/UiHelpers/Utils/Color_Palette/color_palette.dart';

class Chatroom extends StatefulWidget {
  const Chatroom({
    super.key,
    required this.chatRoomId,
    required this.name,
    required this.status,
  });
  final String chatRoomId;
  final String name, status;

  @override
  State<Chatroom> createState() => _ChatroomState();
}

class _ChatroomState extends State<Chatroom> {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Scaffold(
        appBar: appBar(widget.name, widget.status),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: fireStore
                        .collection("chatRoom")
                        .doc(widget.chatRoomId)
                        .collection("chats")
                        .orderBy("time", descending: false)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Palette.primaryColor,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text("Error: ${snapshot.error}"),
                        );
                      } else if (!snapshot.hasData ||
                          snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Text("No Messages Yet"),
                        );
                      } else {
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            return Message(
                              map: snapshot.data!.docs[index].data(),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
                MessageInput(
                  chatRoomId: widget.chatRoomId,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget appBar(String name, String status) {
    return AppBar(
      leadingWidth: 20,
      title: Row(
        spacing: 15,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Palette.primaryColor,
            child: Icon(
              Icons.person,
              color: Colors.white,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: GoogleFonts.publicSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                  color: Palette.primaryColor,
                ),
              ),
              Text(
                status,
                style: GoogleFonts.publicSans(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(CupertinoIcons.ellipsis_vertical),
        ),
      ],
    );
  }
}
