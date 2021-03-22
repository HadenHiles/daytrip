import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Trips extends StatefulWidget {
  Trips({Key key}) : super(key: key);

  @override
  _TripsState createState() => _TripsState();
}

class _TripsState extends State<Trips> {
  // Static variables
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('My Trips'),
      ),
      body: StreamBuilder(
        // ignore: deprecated_member_use
        stream: FirebaseFirestore.instance.collection('trips').doc(user.uid).collection('trips').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Text('Loading data... Please Wait...');
          return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                DocumentSnapshot trip = snapshot.data.documents[index];
                return ListTile(
                  //Once we can store our pictures in Firebase, we can uncomment
                  //and then our trips will start with the picture
                  leading: Image.network(
                    trip['imageURL'],
                    height: 50,
                    width: 75,
                  ),
                  title: Text(trip['title']),
                  subtitle: Text(trip['description'].toString()),
                  trailing: GestureDetector(
                      child: IconButton(
                        icon: Icon(
                        Icons.edit_sharp,
                        size: 28,
                      ),
                    onPressed: (){
                      print("You pressed on a trip");

                     },
                    ),
                  ),  
              );
          });
        },
      ),
    );
  }
/*
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 25, right: 25, bottom: 125),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "No trips yet.",
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      ),
    );
  }*/
}
