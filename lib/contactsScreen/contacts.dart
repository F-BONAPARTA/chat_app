import 'package:chat_app/contactsScreen/contact_item_widget.dart';
import 'package:chat_app/profile_Screen/profile_methods.dart';
import 'package:chat_app/profile_Screen/user_profile.dart';
import 'package:chat_app/contactsScreen/add_new_contact.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Contacts extends StatefulWidget {
  static const String id = 'contactsId';

  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  String myImageUrl;
  String myId;
  @override
  void initState() {
    getMyImage();
    super.initState();
  }

  getMyImage() async {
    var user = await FirebaseAuth.instance.currentUser();
    setState(() {
      myId = user.uid;
    });
    var snapshot =
        await Firestore.instance.collection('users').document(user.uid).get();
    setState(() {
      myImageUrl = snapshot.data['image'];
    });
  }

  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Material(
                    elevation: 5,
                    shape: CircleBorder(),
                    child: IconButton(
                      icon: Icon(
                        Icons.search,
                        size: deviceWidth * 0.07,
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed(AddContact.id);
                      },
                    ),
                  ),
                  Text(
                    'contacts',
                    style: TextStyle(
                        fontFamily: 'font', color: Colors.black, fontSize: 30),
                  ),
                  GestureDetector(
                    onTap: () {
                      ProfileMethods.showUserName();
                      ProfileMethods.showUserStatus();
                      Navigator.pushNamed(context, ProfileUserScreen.id);
                    },
                    child: Material(
                        elevation: 15,
                        shape: CircleBorder(),
                        child: Hero(
                          tag: 'tag',
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: deviceWidth * 0.066,
                            backgroundImage: myImageUrl == null
                                ? null
                                : NetworkImage(myImageUrl),
                          ),
                        )),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
              child: FutureBuilder(
                future: FirebaseAuth.instance.currentUser(),
                builder: (context, futureSnapshot) {
                  if (futureSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return StreamBuilder(
                    stream: Firestore.instance
                        .collection('users/${futureSnapshot.data.uid}/contacts')
                        .snapshots(),
                    builder: (context, streamSnapshot) {
                      if (streamSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      final documents = streamSnapshot.data.documents;

                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: documents.length,
                        itemBuilder: (context, index) => ContactItem(
                            context,
                            documents[index]['contactId'],
                            futureSnapshot.data.uid),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
