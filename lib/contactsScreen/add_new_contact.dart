import 'package:chat_app/contactsScreen/contacts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddContact extends StatefulWidget {
  static const String id = 'add';
  @override
  _AddContactState createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  var list = [];
  var textFieldValue = '';
  onSearch(value) async {
    var dataFromFireBase =
        await Firestore.instance.collection('users').getDocuments();
    setState(() {
      list = dataFromFireBase.documents
          .where((element) => element['username'].contains(value))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Material(
                      elevation: 5,
                      shape: CircleBorder(),
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          size: deviceWidth * 0.07,
                        ),
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, Contacts.id);
                        },
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Material(
                        elevation: 3,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          height: 50,
                          child: TextField(
                            onChanged: onSearch,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.only(left: deviceWidth * 0.14),
                              hintText: 'Enter Contact Name',
                              hintStyle: TextStyle(
                                  fontFamily: 'font',
                                  fontSize: deviceWidth * 0.05),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: InkWell(
                        onTap: () async {
                          try {
                            var user =
                                await FirebaseAuth.instance.currentUser();
                            var snapshot = await Firestore.instance
                                .collection('users')
                                .document(user.uid)
                                .get();
                            bool exist = false;
                            var myList = await Firestore.instance
                                .collection('users/${user.uid}/contacts')
                                .getDocuments();
                            for (int i = 0; i < myList.documents.length; i++) {
                              if (myList.documents[i]['contactId'] ==
                                  list[index]['userId']) {
                                exist = true;
                              }
                            }
                            if (exist) {
                              Navigator.pushReplacementNamed(
                                  context, Contacts.id);
                            } else if (user.uid == list[index]['userId']) {
                              await Firestore.instance
                                  .collection('users/${user.uid}/contacts')
                                  .add({
                                'contactId': list[index]['userId'],
                              });
                            } else {
                              await Firestore.instance
                                  .collection('users/${user.uid}/contacts')
                                  .add({
                                'contactId': list[index]['userId'],
                              });
                              await Firestore.instance
                                  .collection(
                                      'users/${list[index]['userId']}/contacts')
                                  .add({
                                'contactId': user.uid,
                              });
                            }
                            Navigator.pushReplacementNamed(
                                context, Contacts.id);
                          } catch (e) {
                            Navigator.pushReplacementNamed(
                                context, Contacts.id);
                          }
                        },
                        child: ListTile(
                          title: Text(
                            list[index]['username'],
                            style: TextStyle(fontSize: 25),
                          ),
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(list[index]['image']),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
