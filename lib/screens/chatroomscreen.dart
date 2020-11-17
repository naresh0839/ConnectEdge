import 'package:connectedge2/helper/authentication.dart';
import 'package:connectedge2/helper/constants.dart';
import 'package:connectedge2/helper/database.dart';
import 'package:connectedge2/helper/helperfunctions.dart';
import 'package:connectedge2/screens/about_us.dart';
import 'package:connectedge2/screens/conversation_screen.dart';
import 'package:connectedge2/screens/issue_screen.dart';
import 'package:connectedge2/screens/profile_page.dart';
import 'package:connectedge2/screens/search.dart';
import 'package:connectedge2/services/auth.dart';
import 'package:connectedge2/widgets/widget.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Stream chatRoomsStream;

  Widget chatRoomList() {
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context, snapshot){
        return snapshot.hasData ? ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index){
              return ChatRoomTile(
                userName: snapshot.data.documents[index].data["chatroomid"]
                    .toString().replaceAll("_", "")
                    .replaceAll(Constants.myName, ""),
                chatRoomId: snapshot.data.documents[index].data["chatroomid"],
              );
            }
        ) : Container();
      },
    );
  }
  @override
  void initState(){
    getUserDetail();
    super.initState();
  }
  getUserDetail() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    Constants.myEmail = await HelperFunctions.getUserEmailSharedPreference();
    databaseMethods.getChatRooms(Constants.myName).then((value) {
      setState(() {
        chatRoomsStream = value;
      });
    });
    databaseMethods.getUserByUserEmail(Constants.myEmail).then((result) async {
      setState(() {
        profilePicUrl = result.documents[0].data["profileUrl"];
      });
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.0),
                color: Colors.grey[850],
                child: Center(
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 30,),
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 4,
                                color: Theme.of(context).scaffoldBackgroundColor),
                            boxShadow: [
                              BoxShadow(
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  color: Colors.black.withOpacity(0.1),
                                  offset: Offset(0, 10))
                            ],
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: (profilePicUrl == null ? NetworkImage('https://cdn3.iconfinder.com/data/icons/galaxy-open-line-gradient-i/200/contacts-512.png') : NetworkImage(profilePicUrl))
                            )),
                      ),
                      SizedBox(height: 10,),
                      Text(
                          "${Constants.myName}",
                          style:TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                          )
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                color: Colors.grey[800],
                child: ListTile(
                  leading: Icon(Icons.person,color: Colors.white,),
                  title:Text(
                    "Edit profile",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,MaterialPageRoute(
                      builder: (context)=> ProfilePage(),
                    )
                    );
                  },
                ),
              ),
              Container(
                color: Colors.grey[800],
                child: ListTile(
                  leading: Icon(Icons.comment,color: Colors.white,),
                  title:Text(
                    "Raise An Issue",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,MaterialPageRoute(
                      builder: (context)=> RaiseIssue(),
                    )
                    );
                  },
                ),
              ),
              // Logout Button
              Container(
                color: Colors.grey[800],
                child: ListTile(
                  leading: Icon(Icons.arrow_back,color: Colors.white,),
                  title:Text(
                    "Logout",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    authMethods.signOut();
                    HelperFunctions.saveUserLoggedInSharedPreference(false);
                    Navigator.pushReplacement(
                        context,MaterialPageRoute(
                      builder: (context)=> Authentication(),
                    )
                    );
                  },
                ),
              ),
              Container(
                color: Colors.grey[800],
                child: ListTile(
                  leading: Icon(Icons.group_add,color: Colors.white,),
                  title:Text(
                    "About us",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,MaterialPageRoute(
                      builder: (context)=> AboutUs(),
                    )
                    );
                  },
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.grey[800],
                ),
              ),
            ],
          ) ,
        ),
        backgroundColor: Colors.grey[800],
        appBar: AppBar(
          backgroundColor : Colors.grey[850],
          centerTitle: true,
          title: Text('𝕮𝖔𝖓𝖓𝖊𝖈𝖙 𝕰𝖉𝖌𝖊',
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              )
          ),
        ),
        body: chatRoomList(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.grey[850],
          child: Icon(Icons.search),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => SearchScreen()
            ));
          },
        ),
    );
  }
}

class ChatRoomTile extends StatefulWidget {

  final String userName;
  final String chatRoomId;
  ChatRoomTile({this.userName, this.chatRoomId});

  @override
  _ChatRoomTileState createState() => _ChatRoomTileState();
}

class _ChatRoomTileState extends State<ChatRoomTile> {
  String picUrl;

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
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => ConversationScreen(widget.chatRoomId)
        ));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
                Text(widget.userName, style: mediumTextStyle(),),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
