import 'package:chat_app/constats.dart';
import 'package:flutter/material.dart';

import '../time_calc.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String _imageUrl;
  var time;
  MessageBubble(this.message, this.isMe, this._imageUrl, this.time);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          message == ''
              ? SizedBox(
                  height: 0,
                )
              : isMe
                  ? Column(
                      children: [
                        Material(
                          elevation: 7.0,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(0),
                          ),
                          color: kMainColor,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: Text(
                              message,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Material(
                          elevation: 7.0,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(12),
                          ),
                          color: Colors.grey[600],
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: Text(
                              message,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
          SizedBox(
            height: 5,
          ),
          _imageUrl == null
              ? SizedBox(
                  height: 0,
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Row(
                    mainAxisAlignment:
                        isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showGeneralDialog(
                            context: context,
                            barrierDismissible: true,
                            barrierLabel: MaterialLocalizations.of(context)
                                .modalBarrierDismissLabel,
                            barrierColor: Colors.black,
                            transitionDuration: Duration(milliseconds: 200),
                            pageBuilder: (BuildContext context, Animation first,
                                Animation second) {
                              return Center(
                                child: Image.network(_imageUrl),
                              );
                            },
                          );
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Image.network(_imageUrl),
                        ),
                      ),
                    ],
                  ),
                ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  readTimestamp(time),
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
