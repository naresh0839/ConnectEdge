import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{
  
  getUserByUsername(String userName) async {
    return await Firestore.instance.collection("users")
        .where("name", isEqualTo: userName)
        .getDocuments();
  }

  getUserByUserEmail(String userEmail) async {
    return await Firestore.instance.collection("users")
        .where("email", isEqualTo: userEmail)
        .getDocuments();
  }

  uploadUserInfo(userMap){
    DocumentReference documentReference = Firestore.instance.collection('users').document();
    documentReference.setData({
      'name' : userMap['name'],
      'email' : userMap['email'],
      'profileUrl' : "https://cdn3.iconfinder.com/data/icons/galaxy-open-line-gradient-i/200/contacts-512.png",
      'id' : documentReference.documentID
    });
  }

  createChatRoom(String chatroomid, chatRoomMap){
    Firestore.instance.collection("ChatRoom")
        .document(chatroomid).setData(chatRoomMap).catchError((e){
          print(e.toString());
    });
  }

  addConversationMessages(String chatRoomId, messageMap){
    Firestore.instance.collection("ChatRoom")
        .document(chatRoomId)
        .collection("chats")
        .add(messageMap).catchError((e) {print(e.toString());});
  }

  getConversationMessages(String chatRoomId) async {
    return await Firestore.instance.collection("ChatRoom")
        .document(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: false)
        .snapshots();
  }

  getChatRooms(String userName) async {
    return await Firestore.instance
        .collection("ChatRoom")
        .where("users", arrayContains: userName)
        .snapshots();
  }

}