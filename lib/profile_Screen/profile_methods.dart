import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileMethods {
  static String kShowUserName;
  static String kShowStatus;
  static showUserName() async {
    var user = await FirebaseAuth.instance.currentUser();
    var snapshot =
        await Firestore.instance.collection('users').document(user.uid).get();

    kShowUserName = snapshot.data['username'];
  }

  static updateUserName(String newUserName) async {
    var user = await FirebaseAuth.instance.currentUser();
    var snapshot = await Firestore.instance
        .collection('users')
        .document(user.uid)
        .updateData({
      'username': newUserName,
    });
  }

  static showUserStatus() async {
    var user = await FirebaseAuth.instance.currentUser();
    var snapshot =
        await Firestore.instance.collection('users').document(user.uid).get();

    kShowStatus = snapshot.data['status'];
  }

  static updateUserStatus(String newUserEmail) async {
    var user = await FirebaseAuth.instance.currentUser();
    var snapshot = await Firestore.instance
        .collection('users')
        .document(user.uid)
        .updateData({
      'status': newUserEmail,
    });
  }
}
