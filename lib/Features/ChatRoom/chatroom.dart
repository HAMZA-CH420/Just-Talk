import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_talk/Features/ChatRoom/Widgets/message.dart';
import 'package:just_talk/Features/ChatRoom/Widgets/message_input.dart';
import 'package:just_talk/Features/ChatRoom/viewModel/chat_provider.dart';
import 'package:just_talk/Features/ProfileScreen/profile_screen.dart';
import 'package:just_talk/UiHelpers/Utils/Color_Palette/color_palette.dart';
import 'package:provider/provider.dart';

class Chatroom extends StatefulWidget {
  const Chatroom({
    super.key,
    required this.chatRoomId,
    required this.name,
    required this.status,
    required this.otherUserId,
  });
  final String chatRoomId;
  final String name, status, otherUserId;

  @override
  State<Chatroom> createState() => _ChatroomState();
}

class _ChatroomState extends State<Chatroom> with WidgetsBindingObserver {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _markAsRead();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _markAsRead();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Scaffold(
        appBar: appBar(widget.name, widget.status, widget.otherUserId),
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
                        .collection("messages")
                        .orderBy("timeStamp", descending: false)
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
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (_scrollController.hasClients) {
                            _scrollController.jumpTo(
                                _scrollController.position.maxScrollExtent);
                          }
                        });
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            return Message(
                              map: snapshot.data!.docs[index].data(),
                            );
                          },
                          controller: _scrollController,
                        );
                      }
                    },
                  ),
                ),
                MessageInput(
                  chatRoomId: widget.chatRoomId,
                  otherUserId: widget.otherUserId,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget appBar(String name, String status, String otherUserId) {
    return AppBar(
      leadingWidth: 20,
      scrolledUnderElevation: 0.0,
      elevation: 0,
      backgroundColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
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
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(userId: otherUserId),
                  ));
            },
            child: Column(
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

  _markAsRead() {
    if (mounted) {
      context.read<ChatProvider>().markMessagesAsReadAndResetUnreadCount(
          chatRoomId: widget.chatRoomId,
          currentUserId: FirebaseAuth.instance.currentUser!.uid,
          otherUserId: widget.otherUserId);
    }
  }
}
