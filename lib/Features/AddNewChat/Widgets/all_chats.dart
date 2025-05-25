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
          return waitingIndicator();
        } else if (snapshot.hasError) {
          return Center(
            child: Text("Unknown Error"),
          );
        }
        if (userMap.isEmpty) {
          return Center(child: Text("No User Found"));
        } else {
          return Consumer<ChatProvider>(
            builder: (context, value, child) {
              return ListView.builder(
                itemCount: userMap.length,
                itemBuilder: (context, index) {
                  final currentUserId = auth.currentUser?.uid;
                  final otherUserId = userMap.keys.elementAt(index);
                  final otherUserData = userMap[otherUserId];

                  if (currentUserId == otherUserId) {
                    return SizedBox.shrink();
                  } else {
                    final chatRoomId = context
                        .read<ChatProvider>()
                        .chatRoomId(currentUserId, otherUserData["uid"]);
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
                                userId: otherUserData["name"],
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

  ///Method to create new collection where all our home screen chats will be stored
  Future<void> createMyChatsCollection(
    String docName,
    String name,
    String status,
    String uid,
  ) async {
    fireStore
        .collection(auth.currentUser!.displayName ?? "myChats")
        .doc(docName)
        .set({
      "name": name,
      "status": status,
      "uid": uid,
    });
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
