import 'package:chat_app/chat/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../time_calc.dart';

class ContactItem extends StatefulWidget {
  String friendId;
  String myId;

  ContactItem(BuildContext context, this.friendId, this.myId);

  @override
  _ContactItemState createState() => _ContactItemState();
}

class _ContactItemState extends State<ContactItem> {
  String labelText = '';
  int time = 0;
  getChatDocs() async {
    var snapshots = await Firestore.instance
        .collection('chats/${widget.myId}+${widget.friendId}/messages')
        .orderBy('createdAt', descending: true)
        .getDocuments();
    labelText = snapshots.documents[0]['text'];
    time = snapshots.documents[0]['time'];
  }

  @override
  void initState() {
    getChatDocs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;
    return FutureBuilder(
      future: Firestore.instance
          .collection('users')
          .document(widget.friendId)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text('');
        }
        return InkWell(
          onTap: () {
            Navigator.pushNamed(context, ChatScreen.id, arguments: {
              'friendId': widget.friendId,
              'name': snapshot.data['username'],
              'image': snapshot.data['image'],
            });
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Material(
                            elevation: 5,
                            shape: CircleBorder(),
                            child: CircleAvatar(
                              radius: deviceWidth * 0.066,
                              backgroundImage:
                                  NetworkImage(snapshot.data['image']),
                            )),
                        SizedBox(
                          width: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.data['username'],
                              style: TextStyle(
                                  fontSize: deviceWidth * 0.05,
                                  fontFamily: 'font',
                                  fontWeight: FontWeight.w400),
                            ),
                            labelText == null
                                ? Text('')
                                : labelText.length > 30
                                    ? Text(
                                        labelText.substring(0, 18),
                                        style:
                                            TextStyle(color: Colors.grey[800]),
                                      )
                                    : Text(
                                        labelText,
                                        style:
                                            TextStyle(color: Colors.grey[800]),
                                      ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      readTimestamp(time),
                      style: TextStyle(fontFamily: 'font'),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.15),
                  child: Divider(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
