import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectedge2/helper/constants.dart';
import 'package:connectedge2/helper/database.dart';
import 'package:connectedge2/screens/conversation_screen.dart';
import 'package:connectedge2/widgets/widget.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchTextEditingController = new TextEditingController();

  QuerySnapshot searchSnapshot;

  startSearch(){
    databaseMethods.getUserByUsername(searchTextEditingController.text).then((val){
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  Widget searchList(){
    return searchSnapshot == null ? Container() : ListView.builder(
      itemCount: searchSnapshot.documents.length,
      shrinkWrap: true,
      itemBuilder: (context, index){
        return SearchTile(
          userName: searchSnapshot.documents[index].data["name"],
          userEmail: searchSnapshot.documents[index].data["email"],
        );
      }
    );
  }

  // createChatroom and push the user to that room pushReplacement
  /*createChatRoomWithUser({String friendName}){
    if(friendName != Constants.myName){
      String chatRoomId = createChatRoomID(friendName, Constants.myName);
      List<String> users = [friendName, Constants.myName];

      Map<String, dynamic> chatRoomMap = {
        "users" : users,
        "chatroomid" : chatRoomId
      };

      databaseMethods.createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => ConversationScreen(
            chatRoomId
          )
      ));
    } else {
      print("user cannot chat with himself");
    }
  }*/

  // ignore: non_constant_identifier_names
  /*Widget SearchTile({String userName, String userEmail}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userName, style: mediumTextStyle(),),
              Text(userEmail, style: mediumTextStyle(),)
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: (){
              createChatRoomWithUser(
                friendName : userName
              );
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(30)
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text("Message", style: mediumTextStyle(),),
            ),
          )
        ],
      ),
    );
  }*/

  @override
  void initState(){
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: appBarMain(context),
      body: Container(
        color: Colors.grey[800],
        child: Column(
          children: [
            Container(
              color: Colors.grey[800],
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                        controller: searchTextEditingController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(color: Colors.white)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          hintText: "Search Username...",
                          hintStyle: TextStyle(
                            color: Colors.white54
                          ),
                        ),
                      )
                  ),
                  SizedBox(width: 10,),
                  GestureDetector(
                    onTap: (){
                      startSearch();
                    },
                    child: Container(
                        height: 42,
                        width: 42,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0x36FFFFFF),
                              const Color(0x0FFFFFFF),
                            ]
                          ),
                          borderRadius: BorderRadius.circular(60)
                        ),
                        padding: EdgeInsets.all(12),
                        child: Image.asset("assets/images/search_white.png")
                    ),
                  )
                ],
              ),
            ),
            searchList()
          ],
        ),
      ),
    );
  }
}

createChatRoomID(String a, String b){
  if(a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else{
    return "$a\_$b";
  }
}

class SearchTile extends StatefulWidget {

  final String userName;
  final String userEmail;
  SearchTile({this.userName, this.userEmail});

  @override
  _SearchTileState createState() => _SearchTileState();
}

class _SearchTileState extends State<SearchTile> {
  String picUrl;

  DatabaseMethods databaseMethods = new DatabaseMethods();

  getProfilePics() async {
    await DatabaseMethods().getUserByUsername(widget.userName)
        .then((result) async {
      var userDetails = result;
      setState(() {
        picUrl = userDetails.documents[0].data["profileUrl"];
      });
    });
  }
  @override
  void initState() {
    getProfilePics();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black38,
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                minRadius: 25.0,
                backgroundColor: Colors.white,
                backgroundImage: (picUrl == null ? NetworkImage('https://cdn3.iconfinder.com/data/icons/galaxy-open-line-gradient-i/200/contacts-512.png') : NetworkImage(picUrl)),
              ),
              SizedBox(width: 8,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.userName, style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                      fontSize: 19
                  ),),
                  SizedBox(height: 3,),
                  Text(widget.userEmail, style: TextStyle(
                      color: Colors.white,
                      fontSize: 15
                  ),)
                ],
              ),
              Spacer(),
              GestureDetector(
                onTap: (){
                  createChatRoomWithUser(
                      friendName : widget.userName
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20.0)
                  ),
                  padding: EdgeInsets.all(10),
                  child: Icon(
                      Icons.send,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  void createChatRoomWithUser({String friendName}){
    if(friendName != Constants.myName){
      String chatRoomId = createChatRoomID(friendName, Constants.myName);
      List<String> users = [friendName, Constants.myName];

      Map<String, dynamic> chatRoomMap = {
        "users" : users,
        "chatroomid" : chatRoomId
      };

      databaseMethods.createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => ConversationScreen(
              chatRoomId
          )
      ));
    } else {
      print("user cannot chat with himself");
    }
  }
}