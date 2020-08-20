import 'dart:io';
import 'package:chat_app/auth_screens/start_Screen.dart';
import 'package:chat_app/constats.dart';
import 'package:chat_app/profile_Screen/profile_data.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';
import 'curveCalc.dart';

class ProfileUserScreen extends StatefulWidget {
  static String id = 'lkaslask';

  @override
  _ProfileUserScreenState createState() => _ProfileUserScreenState();
}

class _ProfileUserScreenState extends State<ProfileUserScreen> {
  String firebaseUserImage;
  var _imageUrl;
  void initState() {
    super.initState();
    profilePic();
  }

  profilePic() async {
    var user = await FirebaseAuth.instance.currentUser();
    var snapshot =
        await Firestore.instance.collection('users').document(user.uid).get();
    String imageUlr = snapshot.data['image'];
    setState(() {
      firebaseUserImage = imageUlr;
    });
  }

  takeImage() async {
    try {
      var user = await FirebaseAuth.instance.currentUser();
      var userId = user.uid;
      final picker = ImagePicker();
      final pickedImage = await picker.getImage(source: ImageSource.gallery);
      final pickedImageFile = File(pickedImage.path);
      final ref =
          FirebaseStorage.instance.ref().child('users_images').child(userId);
      await ref.putFile(pickedImageFile).onComplete;

      _imageUrl = await ref.getDownloadURL();
      setState(() {
        firebaseUserImage = _imageUrl;
      });
      await Firestore.instance
          .collection('users')
          .document(userId)
          .updateData({'image': _imageUrl});
    } catch (e) {
      print(e.message);
    }
  }

  imageFullScreen(context, String url) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black,
      transitionDuration: Duration(milliseconds: 200),
      pageBuilder: (BuildContext context, Animation first, Animation second) {
        return Center(
          child: Image.network(url),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
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
                        onTap: firebaseUserImage == null
                            ? null
                            : () => imageFullScreen(context, firebaseUserImage),
                        child: Hero(
                          tag: 'tag',
                          child: CircleAvatar(
                            radius: deviceWidth * 0.13,
                            backgroundColor: Colors.white,
                            backgroundImage: firebaseUserImage == null
                                ? null
                                : NetworkImage(firebaseUserImage),
                          ),
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
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: FlatButton.icon(
                            label: Text(
                              'SignOut',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.5,
                              ),
                            ),
                            icon: Icon(
                              Icons.exit_to_app,
                              color: Colors.white,
                              size: 30,
                            ),
                            onPressed: () async {
                              await FirebaseAuth.instance.signOut();
                              Navigator.pushReplacementNamed(
                                  context, StartScreen.id);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: deviceHeight * 0.2,
                    left: deviceWidth * 0.5,
                    child: RaisedButton(
                      color: kMainColor,
                      onPressed: takeImage,
                      shape: CircleBorder(),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              ProfileData(),
            ],
          ),
        ),
      ),
    );
  }
}
