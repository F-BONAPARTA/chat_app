
import 'package:flutter/material.dart';

import 'login_screen.dart';
import './register_screen.dart';

class StartScreen extends StatefulWidget {
  static const String id = 'startID';
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  int _selected = 0;
  @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        body: DefaultTabController(
          length: 2,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 26, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TabBar(
                              onTap: (index) {
                                setState(() {
                                  _selected = index;
                                });
                              },
                              indicatorColor: Colors.black,
                              tabs: [
                                Text(
                                  'Login',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: deviceWidth * 0.037),
                                ),
                                Text(
                                  'SignUp',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: deviceWidth * 0.029),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.35,
                          ),
                          Container(
                            width: deviceWidth * .1,
                            child: Image.asset('assets/images/chat.png'),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: deviceHeight * 0.05,
                      ),
                      _selected == 0 ? LoginPart() : SignUpPart(),
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
