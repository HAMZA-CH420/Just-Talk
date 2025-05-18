import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_talk/Features/ChatRoom/chatroom.dart';
import 'package:just_talk/UiHelpers/Utils/Color_Palette/color_palette.dart';

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
    return FutureBuilder(
      future: _fetchMyChatsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Palette.primaryColor,
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text("Unknown Error"));
        } else {
          return ListView.builder(
            itemCount: myChats.length,
            itemBuilder: (context, index) {
              final currentUserId = auth.currentUser?.displayName;
              final otherUserId = myChats.keys.elementAt(index);
              final otherUserData = myChats[otherUserId];
              if (myChats.isEmpty) {
                return Center(child: Text("No user found!"));
              } else {
                return ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Chatroom(),
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
              }
            },
          );
        }
      },
    );
  }

  /// Method to fetch all users from DB
  Future fetchMyChats() async {
    try {
      QuerySnapshot querySnapshot = await fireStore.collection("myChats").get();

      myChats = Map.fromEntries(querySnapshot.docs.map(
        (doc) => MapEntry(doc.id, doc.data()),
      ));
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
