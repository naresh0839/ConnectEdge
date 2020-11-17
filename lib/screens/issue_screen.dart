import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectedge2/helper/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

showAlertDialog(BuildContext context) {
  // Create button
  Widget okButton =  RaisedButton(
    child: Text("OK",
      style: TextStyle(
        color: Colors.white,
        fontSize: 15.0,
        fontWeight: FontWeight.bold,
      ),
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(25.0),
    ),
    color: Colors.grey[800],
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0))
    ),
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Successfully Submitted!!!",
          style: TextStyle(
            color: Colors.black,
            fontSize: 17.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 3,),
        Divider(
          thickness: 1,
        ),
        SizedBox(height: 3,),
        Text("We will try to resolve your issue.",
            style: TextStyle(
              color: Colors.black,
              fontSize: 17.0,
            )
        ),
      ],
    ),
    backgroundColor: Colors.white,
    actions: [
      okButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}


class RaiseIssue extends StatefulWidget {
  @override
  _RaiseIssueState createState() => _RaiseIssueState();
}

class _RaiseIssueState extends State<RaiseIssue> {

  TextEditingController issueDescription = new TextEditingController();
  final formKey = GlobalKey<FormState>();
  DatabaseMethods dataService = new DatabaseMethods();

  raiseIt() async {
    Map<String, String> issue = {
      "problem" : issueDescription.text,
    };
    await Firestore.instance.collection('issues').add(issue);
    issueDescription.clear();
    setState(() {
      showAlertDialog(context);
      // Scaffold.of(context).showSnackBar(SnackBar(content: Text('We will try to resolve your issue'),));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text(
          'Raise An Issue',
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
        padding: EdgeInsets.fromLTRB(15.0, 40.0, 15.0, 40.0),
        child: Container(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(40.0))
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Please write the problem you are facing with the app, we will try to resolve it as soon as possible.',
                            style: TextStyle(
                              fontSize: 20,
                              letterSpacing: 0.8,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          SizedBox(height: 30,),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [BoxShadow(
                                    color: Color.fromRGBO(128,128,128, .5),
                                    blurRadius: 20,
                                    offset: Offset(0, 10)
                                )]
                            ),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border(bottom: BorderSide(color: Colors.grey[200]))
                                  ),
                                  child: TextFormField(
                                    controller: issueDescription,
                                    decoration: InputDecoration(
                                        hintText: "Enter the issue",
                                        hintStyle: TextStyle(color: Colors.grey),
                                        border: InputBorder.none
                                    ),
                                    minLines: 1,
                                    maxLines: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 30,),
                          GestureDetector(
                            onTap: (){
                              raiseIt();
                            },
                            child: Container(
                              height: 50,
                              margin: EdgeInsets.symmetric(horizontal: 50),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.grey[700]
                              ),
                              child: Center(
                                child: Text("Submit", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
