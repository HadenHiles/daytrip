import 'package:daytrip/models/firestore/Trip.dart';
import 'package:daytrip/tabs/trips/TripItem.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Trips extends StatefulWidget {
  Trips({Key key}) : super(key: key);

  final List<String> list = List.generate(10, (index) => "Text $index");

  // final Value<String> values = value;

  @override
  _TripsState createState() => _TripsState();
}

class _TripsState extends State<Trips> {
  // Static variables
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          TextField(
            cursorColor: Theme.of(context).textTheme.bodyText1.color,
            style: Theme.of(context).textTheme.bodyText1,
            decoration: InputDecoration(
              hintStyle: Theme.of(context).textTheme.bodyText1,
              border: InputBorder.none,
              hintText: 'Enter a search term',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (value) {
              //  String values = value;
            },
          ),
          StreamBuilder<QuerySnapshot>(
            // ignore: deprecated_member_use
            stream: FirebaseFirestore.instance
                .collection('trips')
                .doc(user.uid)
                .collection('trips')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Text('Loading data... Please Wait...');
              List<TripItem> trips = [];
              snapshot.data.docs.forEach((doc) {
                trips.add(
                  TripItem(
                    trip: Trip.fromSnapshot(doc),
                  ),
                );
              });
              return Expanded(
                child: ListView(
                  children: trips,
                ),
              );
            },
          ),
        ],
      ),
    );

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
}
