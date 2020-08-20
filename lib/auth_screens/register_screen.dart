import 'package:chat_app/constats.dart';
import 'package:chat_app/contactsScreen/contacts.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpPart extends StatefulWidget {
  @override
  _SignUpPartState createState() => _SignUpPartState();
}

class _SignUpPartState extends State<SignUpPart> {
  bool isLoading = false;

  String _email = '';

  String _password = '';

  String _username = '';

  var _formKey = GlobalKey<FormState>();

  void _trySignUp(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      _formKey.currentState.save();
      try {
        final AuthResult authResult = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _email.trim(), password: _password.trim());
        await Firestore.instance
            .collection('users')
            .document(authResult.user.uid)
            .setData({
          'username': _username,
          'email': _email,
          'userId': authResult.user.uid,
          'password': _password,
        });
        Navigator.pushReplacementNamed(context, Contacts.id);
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(e.message),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RegisterText(),
            SizedBox(
              height: deviceHeight * 0.06,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10, left: 10),
              child: TextFormField(
                onSaved: (value) {
                  _username = value;
                },
                validator: (value) {
                  if (value.isEmpty || value.length < 4) {
                    return 'User name must be 4 characters at least';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    hintText: 'UserName',
                    hintStyle: TextStyle(
                        fontSize: deviceWidth * 0.055, color: Colors.grey)),
              ),
            ),
            isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : SizedBox(
                    height: deviceHeight * 0.03,
                  ),
            Padding(
              padding: const EdgeInsets.only(right: 10, left: 10),
              child: TextFormField(
                onSaved: (value) {
                  _email = value;
                },
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value.isEmpty || !value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    hintText: 'Email Address',
                    hintStyle: TextStyle(
                        fontSize: deviceWidth * 0.055, color: Colors.grey)),
              ),
            ),
            SizedBox(
              height: deviceHeight * 0.03,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10, left: 10),
              child: TextFormField(
                onSaved: (value) {
                  _password = value;
                },
                validator: (value) {
                  if (value.isEmpty || value.length < 6) {
                    return 'Password must be 6 characters at least';
                  }
                  return null;
                },
                obscureText: true,
                decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: TextStyle(
                        fontSize: deviceWidth * 0.055, color: Colors.grey)),
              ),
            ),
            SizedBox(
              height: deviceHeight * 0.168,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(),
                Builder(
                  builder: (context) => InkWell(
                    onTap: () {
                      _trySignUp(context);
                    },
                    child: Container(
                      width: 100,
                      height: 50,
                      child: Icon(
                        Icons.arrow_forward,
                        size: 30,
                        color: Colors.white,
                      ),
                      decoration: BoxDecoration(
                        color: kMainColor,
                        //   color: Color(0xFFEB5757),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Hello',
              style: TextStyle(fontSize: deviceWidth * 0.117),
            ),
            Text(' Beautiful,',
                style: TextStyle(
                    fontSize: deviceWidth * 0.117,
                    fontWeight: FontWeight.bold)),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Text("Enter your information below. ",
            style: TextStyle(fontSize: deviceWidth * 0.055)),
      ],
    );
  }
}
