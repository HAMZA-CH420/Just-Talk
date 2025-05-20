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
  late Map<String, dynamic> myChats;
  late Future<void> _fetchMyChatsFuture;
  @override
  void initState() {
    super.initState();
    _fetchMyChatsFuture = fetchMyChats();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _handleRefresh(),
      child: FutureBuilder(
        future: _fetchMyChatsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return waitingIndicator();
          } else if (snapshot.hasError) {
            return Center(child: Text("Unknown Error"));
          }
          if (myChats.isEmpty) {
            return Center(
              child: GestureDetector(
                onTap: () => _handleRefresh(),
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
              ),
            );
          } else {
            return ListView.builder(
                itemCount: myChats.length,
                itemBuilder: (context, index) {
                  final currentUserId = auth.currentUser?.displayName;
                  final otherUserId = myChats.keys.elementAt(index);
                  final otherUserData = myChats[otherUserId];
                  final chatRoomId = context
                      .read<ChatProvider>()
                      .chatRoomId(currentUserId, otherUserId);
                  return ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 15),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Chatroom(
                              chatRoomId: chatRoomId,
                              name: otherUserData["name"],
                              status: otherUserData["status"],
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
                      "How you doing?",
                      style: GoogleFonts.publicSans(
                          fontSize: 15,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600),
                    ),
                    trailing: Text(
                      otherUserData["status"],
                      style: GoogleFonts.publicSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                  );
                });
          }
        },
      ),
    );
  }

  /// Method to fetch all users from DB
  Future fetchMyChats() async {
    try {
      QuerySnapshot querySnapshot = await fireStore
          .collection(auth.currentUser!.displayName ?? "myChats")
          .get();

      myChats = Map.fromEntries(querySnapshot.docs.map(
        (doc) => MapEntry(doc.id, doc.data()),
      ));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _fetchMyChatsFuture = fetchMyChats();
    });
    await _fetchMyChatsFuture;
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
}
