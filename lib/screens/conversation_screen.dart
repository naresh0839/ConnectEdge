import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectedge2/helper/constants.dart';
import 'package:connectedge2/helper/database.dart';
import 'package:connectedge2/widgets/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ConversationScreen extends StatefulWidget {

  final String chatRoomId;
  ConversationScreen(this.chatRoomId);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {

  TextEditingController messageController = new TextEditingController();
  Stream <QuerySnapshot> chatMessagesStream;

  String friendName;
  String friendPicUrl = "https://cdn3.iconfinder.com/data/icons/galaxy-open-line-gradient-i/200/contacts-512.png";

  Widget chatMessages() {
    ScrollController _controller=ScrollController();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Timer(
          Duration(seconds: 1),
              () => _controller.jumpTo(_controller.position.maxScrollExtent));
    });
    return StreamBuilder(
      stream: chatMessagesStream,
      builder: (context, snapshot){
        return snapshot.hasData ? ListView.builder(
          itemCount: snapshot.data.documents.length,
          controller: _controller,
          itemBuilder: (context, index){
            return MessageTile(
                message : snapshot.data.documents[index].data["message"],
                sendByMe : snapshot.data.documents[index].data["sendBy"] == Constants.myName);
          },
        ) : Container(
          color: Colors.white,
        );
      },
    );
  }

  sendMessage() {
    if(messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message" : messageController.text,
        "sendBy" : Constants.myName,
        "time" : DateTime.now().millisecondsSinceEpoch
      };
      DatabaseMethods().addConversationMessages(widget.chatRoomId, messageMap);
      setState(() {
        messageController.text = "";
      });
    }
  }
  friendNameAndPhoto() async {
    setState(() {
      friendName = widget.chatRoomId.toString().replaceAll("_", "")
          .replaceAll(Constants.myName, "");
    });
    DatabaseMethods().getUserByUsername(friendName).then((result) async {
      setState(() {
        friendPicUrl = result.documents[0].data["profileUrl"];
      });
    });
  }
  @override
  void initState() {
    friendNameAndPhoto();
    DatabaseMethods().getConversationMessages(widget.chatRoomId).then((val) {
      setState(() {
        chatMessagesStream = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        title: Row(
          children: <Widget> [
            CircleAvatar(
              backgroundImage: friendPicUrl == null ? NetworkImage(friendPicUrl) : NetworkImage(friendPicUrl),
            ),
            SizedBox(
              width: 12.0,
            ),
            Text(friendName,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                )
            )
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
                child:Container(
                  child: chatMessages(),
                )
            ),
            Divider(
              thickness: 1,
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 6),
                // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                //color: Colors.white,
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                          controller: messageController,
                          //textAlign: TextAlign.center,
                          style: TextStyle(
                            //height: 0.6,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            hintText: "Type a message",
                            hintStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                            border: new OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: new BorderSide(
                                width: 10,
                                style: BorderStyle.none,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        )
                    ),
                    SizedBox(width: 12,),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[850],
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(
                          color: Colors.black,
                        )
                      ),
                      child: IconButton(
                          icon: Icon(Icons.send),
                          iconSize: 23.0,
                          color: Colors.white,
                          onPressed: () {
                            sendMessage();
                          }
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class MessageTile extends StatelessWidget {

  final String message;
  final bool sendByMe;

  MessageTile({@required this.message, @required this.sendByMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: sendByMe ? 0 : 10,
          right: sendByMe ? 10 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: sendByMe
            ? EdgeInsets.only(left: 30)
            : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(
            top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: sendByMe ? BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomLeft: Radius.circular(23)
            ) :
            BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomRight: Radius.circular(23)),
            gradient: LinearGradient(
              colors: sendByMe ? [
                const Color(0xff007EF4),
                const Color(0xff2A75BC)
              ] : [
                Colors.grey[850],
                Colors.grey[850]
              ],
            )
        ),
        child: Text(message,
            textAlign: TextAlign.start,
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w300)),
      ),
    );
  }
}