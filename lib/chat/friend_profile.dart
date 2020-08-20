import 'package:chat_app/profile_Screen/curveCalc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FriendProfile extends StatefulWidget {
  static const String id = 'frienprofileId';

  @override
  _FriendProfileState createState() => _FriendProfileState();
}

class _FriendProfileState extends State<FriendProfile> {
  @override
  Widget build(BuildContext context) {
    String friendId = ModalRoute.of(context).settings.arguments as String;
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: FutureBuilder(
            future:
                Firestore.instance.collection('users').document(friendId).get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Column(
                children: [
                  new Stack(
                    children: [
                      Column(
                        children: [
                          CurvedShape(),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                      Positioned(
                        top: deviceHeight * 0.1,
                        left: deviceWidth * 0.3768,
                        child: Builder(
                          builder: (context) => GestureDetector(
                            onTap: () {
                              showGeneralDialog(
                                context: context,
                                barrierDismissible: true,
                                barrierLabel: MaterialLocalizations.of(context)
                                    .modalBarrierDismissLabel,
                                barrierColor: Colors.black,
                                transitionDuration: Duration(milliseconds: 200),
                                pageBuilder: (BuildContext context,
                                    Animation first, Animation second) {
                                  return Center(
                                    child:
                                        Image.network(snapshot.data['image']),
                                  );
                                },
                              );
                            },
                            child: CircleAvatar(
                              radius: deviceWidth * 0.13,
                              backgroundColor: Colors.white,
                              backgroundImage:
                                  NetworkImage(snapshot.data['image']),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: 30,
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                            Container(),
                          ],
                        ),
                      ),
                    ],
                  ),
                  FriendProfileData(
                      snapshot.data['username'], snapshot.data['status']),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class FriendProfileData extends StatelessWidget {
  final String _username;
  final String _status;
  FriendProfileData(this._username, this._status);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Material(
              elevation: 5,
              child: ListTile(
                leading: Icon(Icons.person),
                title: Text(_username),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            'Description',
            style: TextStyle(fontFamily: 'font', fontSize: 25),
          ),
          Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              margin: EdgeInsets.all(10),
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width * 0.7,
              child: Text(_status ?? 'No description yet',
                  style: TextStyle(fontFamily: 'font', fontSize: 22)),
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
