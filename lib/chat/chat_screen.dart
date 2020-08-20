import 'dart:io';
import 'package:chat_app/chat/friend_profile.dart';

import 'package:chat_app/constats.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'message_bubble.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'chklsd';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String _enteredMessage = '';

  var _imageUrl;

  var senderController = TextEditingController();

  String friendId;

  var _userID;
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    var deviceWidth = MediaQuery.of(context).size.width;

    friendId = data['friendId'];
    print(friendId);
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
                      Icons.arrow_back,
                      size: deviceWidth * 0.07,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Text(
                  data['name'],
                  style: TextStyle(
                      fontFamily: 'font', color: Colors.black, fontSize: 30),
                ),
                GestureDetector(
                  onTap: () {
                    print(friendId);
                    Navigator.pushNamed(context, FriendProfile.id,
                        arguments: friendId);
                  },
                  child: Material(
                      elevation: 15,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: deviceWidth * 0.066,
                        backgroundImage: NetworkImage(data['image']),
                      )),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: FutureBuilder(
                    future: FirebaseAuth.instance.currentUser(),
                    builder: (context, fsnapshot) {
                      if (fsnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      _userID = fsnapshot.data.uid;
                      return StreamBuilder(
                        stream: Firestore.instance
                            .collection('chats/${_userID}+${friendId}/messages')
                            .orderBy('createdAt', descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          final documents = snapshot.data.documents;
                          return ListView.builder(
                            reverse: true,
                            itemCount: documents.length,
                            itemBuilder: (context, index) => MessageBubble(
                              documents[index]['text'] == null
                                  ? ''
                                  : documents[index]['text'],
                              documents[index]['userId'] == _userID,
                              documents[index]['image'],
                              documents[index]['time'],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 8),
                  padding: EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.camera_alt),
                        onPressed: _uploadImage,
                      ),
                      Expanded(
                        child: TextField(
                          controller: senderController,
                          onChanged: (value) {
                            _enteredMessage = value;
                          },
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(
                                  left: 20, bottom: 11, top: 11, right: 15),
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              hintStyle: TextStyle(
                                  fontFamily: 'font',
                                  fontSize: deviceWidth * 0.05),
                              hintText: 'Send a message...'),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.send,
                          color: kMainColor,
                        ),
                        onPressed: () async {
                          if (senderController.text.trim().isEmpty) {
                            print('object');
                          } else if (_userID == friendId) {
                            senderController.clear();
                            await Firestore.instance
                                .collection(
                                    'chats/${_userID}+${friendId}/messages')
                                .add({
                              'text': _enteredMessage,
                              'createdAt': Timestamp.now(),
                              'userId': _userID,
                              'image': null,
                              'time': DateTime.now().millisecondsSinceEpoch,
                            });
                          } else {
                            senderController.clear();
                            await Firestore.instance
                                .collection(
                                    'chats/${_userID}+${friendId}/messages')
                                .add({
                              'text': _enteredMessage,
                              'createdAt': Timestamp.now(),
                              'userId': _userID,
                              'image': null,
                              'time': DateTime.now().millisecondsSinceEpoch,
                            });
                            /////
                            await Firestore.instance
                                .collection(
                                    'chats/${friendId}+${_userID}/messages')
                                .add({
                              'text': _enteredMessage,
                              'createdAt': Timestamp.now(),
                              'userId': _userID,
                              'image': null,
                              'time': DateTime.now().millisecondsSinceEpoch,
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }

  _uploadImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);
    final pickedImageFile = File(pickedImage.path);
    final ref = FirebaseStorage.instance.ref().child(_userID);
    await ref.putFile(pickedImageFile).onComplete;
    _imageUrl = await ref.getDownloadURL();
    if (_userID == friendId) {
      await Firestore.instance
          .collection('chats/${_userID}+${friendId}/messages')
          .add({
        'text': null,
        'createdAt': Timestamp.now(),
        'userId': _userID,
        'image': _imageUrl,
        'time': DateTime.now().millisecondsSinceEpoch,
      });
    } else {
      await Firestore.instance
          .collection('chats/${_userID}+${friendId}/messages')
          .add({
        'text': null,
        'createdAt': Timestamp.now(),
        'userId': _userID,
        'image': _imageUrl,
        'time': DateTime.now().millisecondsSinceEpoch,
      });
      await Firestore.instance
          .collection('chats/${friendId}+${_userID}/messages')
          .add({
        'text': null,
        'createdAt': Timestamp.now(),
        'userId': _userID,
        'image': _imageUrl,
        'time': DateTime.now().millisecondsSinceEpoch,
      });
    }
  }
}
