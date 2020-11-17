import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        centerTitle: true,
        backgroundColor : Colors.grey[850],
        title: Text('About Us',
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            )
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  color: Colors.white,
                  height: 90,
                  width: 90,
                ),
              ),
              SizedBox(height: 7,),
              Text(
                'ConnectEdge',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white
                ),
              ),
              SizedBox(height: 9,),
              Text(
                'A chat app to connect to your loved ones.',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white54
                ),
              ),
              SizedBox(height: 10,),
              Divider(
                color: Colors.white,
                thickness: 1,
              ),
              SizedBox(height: 10,),
              Text(
                'We have tried to build an app through the project that emphasizes on making users connect to each other conveniently. We have used Flutter SDK (For Frontend) and Firebase for the database purposes. You can also raise an issue if you are having any problem with the app through the "Raise An Issue" section.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white70
                ),
              ),
              SizedBox(height: 10,),
              Divider(
                color: Colors.white,
                thickness: 1,
              ),
              SizedBox(height: 6,),
              Text(
                'Creators',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                ),
              ),
              SizedBox(height: 6,),
              Row(
                children: <Widget> [
                  CircleAvatar(
                    minRadius: 20,
                    backgroundImage: NetworkImage('https://scontent.fluh1-1.fna.fbcdn.net/v/t1.0-9/61803769_2347831218665510_4505572602202292224_n.jpg?_nc_cat=107&ccb=2&_nc_sid=09cbfe&_nc_ohc=oEu7lHV1elMAX-09YFy&_nc_ht=scontent.fluh1-1.fna&oh=afa30034dec81d6c4327ad363d095256&oe=5FD4B7DB'),
                  ),
                  SizedBox(width: 15,),
                  Text(
                    'Naresh Kumar',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                    ),
                  )
                ],
              ),
              SizedBox(height: 8,),
              Row(
                children: <Widget> [
                  CircleAvatar(
                    minRadius: 20,
                    backgroundImage: NetworkImage('https://scontent.fluh1-1.fna.fbcdn.net/v/t1.0-9/78799471_159681158617535_5039761341485678592_n.jpg?_nc_cat=100&ccb=2&_nc_sid=09cbfe&_nc_ohc=IfIm-9xG_RQAX8VG6Sz&_nc_ht=scontent.fluh1-1.fna&oh=72d38d642a617fc624771c382db655fa&oe=5FD0D438'),
                  ),
                  SizedBox(width: 15,),
                  Text(
                    'Md Zuhair',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                    ),
                  )
                ],
              ),
              SizedBox(height: 8,),
              Row(
                children: <Widget> [
                  CircleAvatar(
                    minRadius: 20,
                    backgroundImage: NetworkImage('https://scontent.fluh1-1.fna.fbcdn.net/v/t1.0-9/71065881_2328676400716278_5200096709778079744_o.jpg?_nc_cat=100&ccb=2&_nc_sid=09cbfe&_nc_ohc=T6JfwYT_o7kAX_UpnQg&_nc_ht=scontent.fluh1-1.fna&oh=2e1e7be56de0334566727ffa61bfc60b&oe=5FD34E2C'),
                  ),
                  SizedBox(width: 15,),
                  Text(
                    'Shaan Kumar',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                    ),
                  )
                ],
              ),
              SizedBox(height: 8,),
              Row(
                children: <Widget> [
                  CircleAvatar(
                    minRadius: 20,
                    backgroundImage: NetworkImage('https://scontent.fluh1-1.fna.fbcdn.net/v/t1.0-0/c0.326.1532.1532a/s552x414/72729024_107800633960618_4921697320493383680_o.jpg?_nc_cat=107&ccb=2&_nc_sid=da31f3&_nc_ohc=nvoFReCC8Q0AX9xUlV8&_nc_ht=scontent.fluh1-1.fna&_nc_tp=28&oh=211253d0afd6bcd9da805ba2106e6f93&oe=5FD1D571'),
                  ),
                  SizedBox(width: 15,),
                  Text(
                    'Shashwat Mishra',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
