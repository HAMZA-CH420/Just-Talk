import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_talk/Features/ChatRoom/chatroom.dart';
import 'package:just_talk/Features/ChatRoom/viewModel/chat_provider.dart';
import 'package:just_talk/UiHelpers/Utils/Color_Palette/color_palette.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class AllChats extends StatefulWidget {
  const AllChats({super.key, required this.searchQuery});
  final String searchQuery;
  @override
  State<AllChats> createState() => _AllChatsState();
}

class _AllChatsState extends State<AllChats> {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  late Stream<QuerySnapshot> _streamFuture;
  @override
  void initState() {
    super.initState();
    _streamFuture = fireStore.collection("users").snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _streamFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return waitingIndicator();
        } else if (snapshot.hasError) {
          return Center(
            child: Text("Unknown Error"),
          );
        }
        var userMap = snapshot.data!.docs;
        if (userMap.isEmpty) {
          return Center(child: Text("No User Found"));
        }
        //search Logic
        if (widget.searchQuery.isNotEmpty) {
          userMap = userMap.where(
            (chatDoc) {
              final chatData = chatDoc.data() as Map<String, dynamic>;
              final chatName = chatData['name'] as String? ?? "";
              return chatName.toLowerCase().contains(widget.searchQuery);
            },
          ).toList();
        }

        if (userMap.isEmpty && widget.searchQuery.isNotEmpty) {
          return Center(
            child: Text(
              "No user found!",
              style: GoogleFonts.publicSans(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          );
        }
        return Consumer<ChatProvider>(
          builder: (context, value, child) {
            return ListView.builder(
              itemCount: userMap.length,
              itemBuilder: (context, index) {
                final currentUserId = auth.currentUser?.uid;
                final otherUserId = userMap[index].id;
                final otherUserData =
                    userMap[index].data() as Map<String, dynamic>;

                if (currentUserId == otherUserId) {
                  return SizedBox.shrink();
                } else {
                  final chatRoomId = context
                      .read<ChatProvider>()
                      .chatRoomId(currentUserId, otherUserId);
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 5),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Chatroom(
                              chatRoomId: chatRoomId,
                              name: otherUserData["name"],
                              status: otherUserData["status"],
                              otherUserId: otherUserId,
                            ),
                          ));
                    },
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: Palette.primaryColor,
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      otherUserData["name"],
                      style: GoogleFonts.publicSans(
                          fontSize: 18,
                          color: Palette.primaryColor,
                          fontWeight: FontWeight.w600),
                    ),
                    trailing: Text(
                      otherUserData["status"],
                      style: GoogleFonts.publicSans(
                          fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  );
                }
              },
            );
          },
        );
      },
    );
  }

//Loading indicator
  Widget waitingIndicator() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
            ),
            title: Container(
              height: 15,
              width: double.infinity,
              color: Colors.white,
            ),
            subtitle: Container(
              width: 100,
              height: 15,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}
