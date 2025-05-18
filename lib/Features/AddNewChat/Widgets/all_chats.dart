import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_talk/Features/ChatRoom/chatroom.dart';
import 'package:just_talk/Features/ChatRoom/viewModel/chat_provider.dart';
import 'package:just_talk/UiHelpers/Utils/Color_Palette/color_palette.dart';
import 'package:provider/provider.dart';

class AllChats extends StatefulWidget {
  const AllChats({super.key});

  @override
  State<AllChats> createState() => _AllChatsState();
}

class _AllChatsState extends State<AllChats> {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  late Map<String, dynamic> userMap;
  late Future<void> _fetchUsersFuture;
  @override
  void initState() {
    super.initState();
    _fetchUsersFuture = fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchUsersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Palette.primaryColor,
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text("Unknown Error"),
          );
        } else {
          return Consumer<ChatProvider>(
            builder: (context, value, child) {
              return ListView.builder(
                itemCount: userMap.length,
                itemBuilder: (context, index) {
                  final currentUserId = auth.currentUser?.displayName;
                  final otherUserId = userMap.keys.elementAt(index);
                  final otherUserData = userMap[otherUserId];
                  if (userMap.isEmpty) {
                    return Center(child: Text("No User Found"));
                  }
                  if (currentUserId == otherUserId) {
                    return SizedBox.shrink();
                  } else {
                    return ListTile(
                      onTap: () {
                        createMyChatsCollection(
                            otherUserId,
                            otherUserData["name"],
                            otherUserData["status"],
                            otherUserData["uid"]);
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
        }
      },
    );
  }

  /// Method to fetch all users from DB
  Future fetchUsers() async {
    try {
      QuerySnapshot querySnapshot = await fireStore.collection("users").get();

      userMap = Map.fromEntries(querySnapshot.docs.map(
        (doc) => MapEntry(doc.id, doc.data()),
      ));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //Method to create new collection where all our home screen chats will be stored
  Future<void> createMyChatsCollection(
    String docName,
    String name,
    String status,
    String uid,
  ) async {
    fireStore.collection("myChats").doc(docName).set({
      "name": name,
      "status": status,
      "uid": uid,
    });
  }
}
