import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectedge2/helper/constants.dart';
import 'package:connectedge2/helper/database.dart';
import 'package:connectedge2/widgets/widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  String docId;
  DatabaseMethods dataService = new DatabaseMethods();

  Future uploadImage(BuildContext context) async {
    // ignore: deprecated_member_use
    var _imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    String fileId = randomString(20);

    StorageReference reference = FirebaseStorage.instance.ref().child("$fileId.jpg");
    StorageUploadTask uploadTask = reference.putFile(_imageFile);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();

    await dataService.getUserByUserEmail(Constants.myEmail)
        .then((result) async {
      var userDetails = result;
      setState(() {
        docId = userDetails.documents[0].data["id"];
      });
    });
    await Firestore.instance.collection('users').document(docId).updateData({
      'profileUrl' : downloadUrl,
    });
    setState(() {
      profilePicUrl = downloadUrl;
    });
  }

  Future downloadImage() async {
    setState(() async {
      await dataService.getUserByUserEmail(Constants.myEmail)
          .then((result) async {
        var userDetails = result;
        setState(() {
          profilePicUrl = userDetails.documents[0].data["profileUrl"];
        });
      });
    });
  }

  @override
  void initState() {
    downloadImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text(
          'User Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[850],
        elevation: 0.0,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 150,
                    height: 150,
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
                            image: (profilePicUrl == null ? NetworkImage("https://cdn3.iconfinder.com/data/icons/galaxy-open-line-gradient-i/200/contacts-512.png") : NetworkImage(profilePicUrl))
                        )),
                  ),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          uploadImage(context);
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 4,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                            color: Colors.amberAccent[200],
                          ),
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ),
                      )),
                ],
              ),
            ),
            Divider(
              height: 60.0,
              color: Colors.grey[600],
            ),
            Text(
              'Username',
              style: TextStyle(
                color: Colors.grey,
                letterSpacing: 2.0,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              Constants.myName,
              style: TextStyle(
                color: Colors.amberAccent[200],
                letterSpacing: 2.0,
                fontSize: 26.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30.0),
            Row(
              children: <Widget>[
                Icon(
                  Icons.email,
                  color: Colors.grey[400],
                ),
                SizedBox(width: 10.0),
                Text(
                  Constants.myEmail,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 18.0,
                    letterSpacing: 1.0,
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
