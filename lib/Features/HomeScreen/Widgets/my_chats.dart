import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:just_talk/Features/ChatRoom/chatroom.dart';
import 'package:just_talk/Features/ChatRoom/viewModel/chat_provider.dart';
import 'package:just_talk/UiHelpers/Utils/Color_Palette/color_palette.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class MyChats extends StatefulWidget {
  const MyChats({super.key, required this.searchQuery});
  final String searchQuery;
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
        .orderBy("lastMessageTimeStamp", descending: true)
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
              child: GestureDetector(
                onTap: handleRefresh,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 10,
                  children: [
                    SizedBox(
                      child: SvgPicture.asset("assets/images/no_chats.svg"),
                    ),
                    Text(
                      "Start chatting by pressing the button.",
                      style: GoogleFonts.publicSans(fontSize: 15),
                    ),
                  ],
                ),
              ),
            );
          } else {
            var myChats = snapshot.data!.docs;
            //search Logic
            if (widget.searchQuery.isNotEmpty) {
              myChats = myChats.where(
                (chatDoc) {
                  final chatData = chatDoc.data() as Map<String, dynamic>;
                  final chatName = chatData['name'] as String? ?? "";
                  return chatName.toLowerCase().contains(widget.searchQuery);
                },
              ).toList();
            }

            if (myChats.isEmpty && widget.searchQuery.isNotEmpty) {
              return Center(
                child: Text(
                  "No chats found!",
                  style: GoogleFonts.publicSans(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              );
            }
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
                      if (statusSnapshot.connectionState ==
                              ConnectionState.active &&
                          statusSnapshot.data!.exists &&
                          statusSnapshot.hasData) {
                        final otherUserMainData =
                            statusSnapshot.data!.data() as Map<String, dynamic>;
                        status =
                            otherUserMainData['status'] as String? ?? "offline";
                      }
                      final lastMsg = otherUserData['lastMessage'] as String? ??
                          "No messages";
                      final int unReadMsg =
                          otherUserData['unReadCount'] as int? ?? 0;
                      Timestamp? serverStoredTimeStamp =
                          otherUserData["lastMessageTimeStamp"] as Timestamp?;
                      String displayTime = '';
                      if (serverStoredTimeStamp != null) {
                        DateTime dateTime = serverStoredTimeStamp.toDate();
                        displayTime = DateFormat('hh:mm').format(dateTime);
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
                                  otherUserId: otherUserData['uid'],
                                ),
                              ));
                        },
                        leading: Stack(children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Palette.primaryColor,
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                          ),
                          status == "online"
                              ? Positioned(
                                  child: CircleAvatar(
                                  radius: 8,
                                  backgroundColor: Color(0xFF6ADF0A),
                                ))
                              : SizedBox(),
                        ]),
                        title: Text(
                          otherUserData["name"],
                          style: GoogleFonts.publicSans(
                              fontSize: 18,
                              color: Palette.primaryColor,
                              fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          otherUserData['senderOfLastMessage'] ==
                                  auth.currentUser!.uid
                              ? "You: $lastMsg"
                              : lastMsg,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.publicSans(
                              fontSize: 16,
                              color: Colors.grey,
                              fontWeight: FontWeight.w600),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 8,
                          children: [
                            Text(
                              status == "online" ? "online" : displayTime,
                              style: TextStyle(
                                  fontSize: 13,
                                  color: status == "online"
                                      ? Color(0xFF6ADF0A)
                                      : Colors.grey),
                            ),
                            unReadMsg > 0
                                ? CircleAvatar(
                                    radius: 10,
                                    backgroundColor: Palette.primaryColor,
                                    child: Text(
                                      "$unReadMsg",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  )
                                : SizedBox(),
                          ],
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

//waiting indicator
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
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            subtitle: Container(
              width: 100,
              height: 15,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        );
      },
    );
  }

//method tp handle refresh
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
