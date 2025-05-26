import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_talk/Features/ChatRoom/chatroom.dart';
import 'package:just_talk/Features/ChatRoom/viewModel/chat_provider.dart';
import 'package:just_talk/UiHelpers/Utils/Color_Palette/color_palette.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class MyChats extends StatefulWidget {
  const MyChats({super.key});

  @override
  State<MyChats> createState() => _MyChatsState();
}

class _MyChatsState extends State<MyChats> {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  late Stream<QuerySnapshot> _streamData;

  @override
  void initState() {
    super.initState();
    _streamData = fireStore
        .collection("userChats")
        .doc(auth.currentUser!.uid)
        .collection("chats")
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: handleRefresh,
      color: Palette.primaryColor,
      child: StreamBuilder<QuerySnapshot>(
        stream: _streamData,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return waitingIndicator();
          } else if (snapshot.hasError) {
            return Center(child: Text("Error loading chats."));
          }
          if (snapshot.data!.docs.isEmpty || !snapshot.hasData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 10,
                children: [
                  SizedBox(
                    child: SvgPicture.asset("assets/images/no_chats.svg"),
                  ),
                  Text(
                    "No chats here! Click to refresh",
                    style: GoogleFonts.publicSans(fontSize: 15),
                  ),
                ],
              ),
            );
          } else {
            final myChats = snapshot.data!.docs;
            return ListView.builder(
                itemCount: myChats.length,
                itemBuilder: (context, index) {
                  final currentUserId = auth.currentUser?.uid;
                  final otherUserId = myChats[index].id;
                  final otherUserData =
                      myChats[index].data() as Map<String, dynamic>;
                  if (currentUserId == null) return SizedBox.shrink();
                  final chatRoomId = context
                      .read<ChatProvider>()
                      .chatRoomId(currentUserId, otherUserId);

                  return StreamBuilder<DocumentSnapshot>(
                    stream: fireStore
                        .collection("users")
                        .doc(otherUserId)
                        .snapshots(),
                    builder: (context,
                        AsyncSnapshot<DocumentSnapshot> statusSnapshot) {
                      String status = "offline";
                      String lastMsg = "How you doing";
                      if (statusSnapshot.connectionState ==
                              ConnectionState.active &&
                          statusSnapshot.data!.exists &&
                          statusSnapshot.hasData) {
                        final otherUserMainData =
                            statusSnapshot.data!.data() as Map<String, dynamic>;
                        status =
                            otherUserMainData['status'] as String? ?? "offline";
                        lastMsg = otherUserMainData["lastMsg"] as String ??
                            "No message";
                      }
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 15),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Chatroom(
                                  chatRoomId: chatRoomId,
                                  name: otherUserData["name"],
                                  status: status,
                                  userId: otherUserId,
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
                        subtitle: Text(
                          lastMsg,
                          style: GoogleFonts.publicSans(
                              fontSize: 15,
                              color: Colors.grey,
                              fontWeight: FontWeight.w600),
                        ),
                        trailing: Text(
                          status,
                          style: GoogleFonts.publicSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color:
                                status == "online" ? Colors.green : Colors.grey,
                          ),
                        ),
                      );
                    },
                  );
                });
          }
        },
      ),
    );
  }

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

  Future<void> handleRefresh() async {
    setState(() {
      _streamData = fireStore
          .collection("userChats")
          .doc(auth.currentUser!.uid)
          .collection("chats")
          .snapshots();
    });
  }
}
