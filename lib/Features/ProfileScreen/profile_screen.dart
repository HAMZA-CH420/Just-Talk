import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:just_talk/Features/ProfileScreen/Widgets/edit_user_profile.dart';
import 'package:just_talk/Features/ProfileScreen/Widgets/information_tile.dart';
import 'package:just_talk/UiHelpers/Utils/Color_Palette/color_palette.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.userId});
  final String userId;
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  late Map<String, dynamic> userMap;
  late Future<void> _fetchUsersFuture;
  @override
  void initState() {
    super.initState();
    _fetchUsersFuture = fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
          style: GoogleFonts.publicSans(
            fontSize: 25,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: _fetchUsersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: Center(child: CircularProgressIndicator()));
            } else if (snapshot.hasError) {
              return Center(child: Text("Unknown Error"));
            } else {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  spacing: 18,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 85,
                        backgroundColor: Palette.primaryColor,
                        child: Icon(
                          CupertinoIcons.person,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        InformationTile(
                          title: "Name",
                          subtitle: userMap[widget.userId]["name"],
                          icon: CupertinoIcons.person,
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditUserProfile(
                                  label: "Name",
                                  controllerValue: userMap[widget.userId]
                                      ["name"],
                                ),
                              )),
                          isLoggedUser: userMap[widget.userId]["name"] ==
                              auth.currentUser!.displayName,
                        ),
                        InformationTile(
                          title: "About",
                          subtitle: userMap[widget.userId]["about"],
                          icon: Icons.info_outline,
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditUserProfile(
                                  label: "About",
                                  controllerValue: userMap[widget.userId]
                                      ["about"],
                                ),
                              )),
                          isLoggedUser: userMap[widget.userId]["name"] ==
                              auth.currentUser!.displayName,
                        ),
                        InformationTile(
                          title: "Email Address",
                          subtitle: userMap[widget.userId]["email"],
                          icon: Icons.email_outlined,
                          onTap: () {},
                          isLoggedUser: userMap[widget.userId]["name"] ==
                              auth.currentUser!.displayName,
                        ),
                      ],
                    ),
                    userMap[widget.userId]["name"] ==
                            auth.currentUser!.displayName
                        ? GestureDetector(
                            onTap: () {
                              _showAlertDialog(context);
                            },
                            child: Row(
                              spacing: 8,
                              children: [
                                Text(
                                  "LogOut",
                                  style: GoogleFonts.publicSans(
                                      color: Colors.red, fontSize: 18),
                                ),
                                Icon(
                                  Iconsax.logout,
                                  color: Colors.red,
                                )
                              ],
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
              );
            }
          },
        ),
      ),
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

  //show alert dialog
  _showAlertDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Do you want to logout?",
            style: GoogleFonts.publicSans(
                fontWeight: FontWeight.w600, fontSize: 17),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: Text("No")),
            TextButton(
                onPressed: () async {
                  await auth.signOut();
                  Navigator.popUntil(
                    context,
                    (route) => route.isFirst,
                  );
                },
                child: Text("Yes")),
          ],
        );
      },
    );
  }
}
