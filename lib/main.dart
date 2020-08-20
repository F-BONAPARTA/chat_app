import 'package:chat_app/chat/friend_profile.dart';
import 'package:chat_app/constats.dart';
import 'package:chat_app/contactsScreen/contacts.dart';
import 'package:chat_app/profile_Screen/user_profile.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'auth_screens/start_Screen.dart';
import 'chat/chat_screen.dart';
import 'contactsScreen/add_new_contact.dart';

main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: kMainColor),
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Contacts();
          }
          return StartScreen();
        },
      ),
      routes: {
        ChatScreen.id: (context) => ChatScreen(),
        AddContact.id: (context) => AddContact(),
        StartScreen.id: (context) => StartScreen(),
        Contacts.id: (context) => Contacts(),
        ProfileUserScreen.id: (context) => ProfileUserScreen(),
        FriendProfile.id: (context) => FriendProfile(),
      },
    );
  }
}
