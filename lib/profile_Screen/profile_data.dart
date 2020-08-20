import 'package:chat_app/profile_Screen/profile_methods.dart';
import 'package:chat_app/profile_Screen/user_profile.dart';
import 'package:flutter/material.dart';

class ProfileData extends StatefulWidget {
  @override
  _ProfileDataState createState() => _ProfileDataState();
}

class _ProfileDataState extends State<ProfileData> {
  bool editUsername = false;
  bool editStatus = false;
  bool isArabic = false;
  @override
  Widget edituserName(BuildContext context) {
    var usernameController = TextEditingController();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: usernameController,
              decoration: InputDecoration(
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                hintText: "Enter New Username",
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              if (usernameController.text.length < 4) {
                return Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('username must be at least 4 characters'),
                ));
              } else {
                ProfileMethods.updateUserName(usernameController.text);
                setState(() {
                  editUsername = false;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget editTheStatus(BuildContext context) {
    var statusController = TextEditingController();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        children: [
          TextField(
            textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
            maxLines: 7,
            controller: statusController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RaisedButton(
                color: Colors.grey[50],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Text('save'),
                onPressed: () {
                  if (statusController.text.trim().isEmpty) {
                    return Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text('please enter a text'),
                    ));
                  } else if (statusController.text.length > 120) {
                    return Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text('maxlength should be 120 character'),
                    ));
                  } else {
                    ProfileMethods.updateUserStatus(statusController.text);

                    setState(() {
                      editStatus = false;
                    });
                  }
                },
              ),
              SizedBox(
                width: 10,
              ),
              IconButton(
                icon: isArabic
                    ? Icon(Icons.format_align_right)
                    : Icon(Icons.format_align_left),
                onPressed: () {
                  setState(() {
                    isArabic = !isArabic;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Column(
        children: [
          editUsername
              ? Builder(
                  builder: (context) => edituserName(context),
                )
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Material(
                    elevation: 5,
                    child: ListTile(
                      leading: Icon(Icons.person),
                      title: Text(ProfileMethods.kShowUserName ?? ''),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          setState(() {
                            editUsername = true;
                          });
                        },
                      ),
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
          editStatus
              ? Builder(
                  builder: (context) => editTheStatus(context),
                )
              : InkWell(
                  onTap: () {
                    setState(() {
                      editStatus = true;
                    });
                  },
                  child: Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      margin: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Text(
                          ProfileMethods.kShowStatus ??
                              'Tap to add your description',
                          style: TextStyle(fontFamily: 'font', fontSize: 22)),
                    ),
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
