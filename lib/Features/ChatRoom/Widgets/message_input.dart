import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:just_talk/Features/ChatRoom/viewModel/chat_provider.dart';
import 'package:just_talk/UiHelpers/Utils/Color_Palette/color_palette.dart';
import 'package:provider/provider.dart';

class MessageInput extends StatefulWidget {
  const MessageInput(
      {super.key, required this.chatRoomId, required this.otherUserId});
  final String chatRoomId;
  final String otherUserId;

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final TextEditingController controller = TextEditingController();

  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Row(
      spacing: 5,
      children: [
        Container(
          height: size.height / 18,
          width: size.width / 1.3,
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.only(left: 10),
          padding: const EdgeInsets.symmetric(horizontal: 13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: Palette.secondaryColor,
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Message",
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            context.read<ChatProvider>().sendMessage(
                currentUserId: auth.currentUser!.uid,
                otherUserId: widget.otherUserId,
                msgText: controller.text,
                chatRoomId: widget.chatRoomId);
            controller.clear();
          },
          child: CircleAvatar(
            radius: 24,
            backgroundColor: Palette.primaryColor,
            child: Icon(
              Icons.send,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  //method to send message in our collection
  Future<void> onSendMessage() async {
    Map<String, dynamic> message = {
      "sentBy": auth.currentUser?.displayName,
      "time": DateTime.now(),
      "message": controller.text.toString(),
    };
    await fireStore
        .collection("chatRoom")
        .doc(widget.chatRoomId)
        .collection("chats")
        .add(message);
  }
}
