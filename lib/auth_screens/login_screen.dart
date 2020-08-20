import 'package:chat_app/constats.dart';
import 'package:chat_app/contactsScreen/contacts.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPart extends StatefulWidget {
  @override
  _LoginPartState createState() => _LoginPartState();
}

class _LoginPartState extends State<LoginPart> {
  bool isLoading = false;

  String _email = '';

  String _password = '';

  var _formKey = GlobalKey<FormState>();

  void _tryLogin(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      _formKey.currentState.save();
      try {
        final AuthResult authResult = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: _email.trim(), password: _password.trim());
        isLoading = false;
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
      child: Column(
        children: [
          TitlePart(),
          SizedBox(
            height: deviceHeight * 0.06,
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
                  hintText: 'Email address',
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
            height: deviceHeight * 0.24,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(),
              Builder(
                builder: (context) => InkWell(
                  onTap: () {
                    _tryLogin(context);
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
                      //   color: Color(0xFFF2C94C),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TitlePart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            'Welcome To Our',
            style: TextStyle(fontSize: deviceWidth * 0.1),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Stack(
          children: [
            Center(
              child: Container(
                width: deviceHeight * 0.13,
                height: deviceWidth * 0.2,
                child: Hero(
                    tag: 'tag', child: Image.asset('assets/images/chat.png')),
              ),
            ),
            Positioned(
              left: deviceWidth * 0.56,
              top: deviceHeight * 0.05,
              child:
                  Text('App', style: TextStyle(fontSize: deviceWidth * 0.08)),
            ),
          ],
        ),
      ],
    );
  }
}
