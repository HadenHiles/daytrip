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
  String _searchTerm = "";

  @override
  Widget build(BuildContext context) {
    return Column(
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
            setState(() {
              _searchTerm = value;
            });
          },
        ),
        StreamBuilder<QuerySnapshot>(
          // ignore: deprecated_member_use
          stream: FirebaseFirestore.instance.collection('trips').doc(user.uid).collection('trips').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                ],
              );

            List<TripItem> trips = [];
            snapshot.data.docs.forEach((doc) {
              trips.add(
                TripItem(
                  trip: Trip.fromSnapshot(doc),
                ),
              );
            });

            List<TripItem> tripItems = trips.where((t) {
              return (t.trip.title.contains(_searchTerm) || t.trip.description.contains(_searchTerm) || t.trip.address.contains(_searchTerm));
            }).toList();

            return Expanded(
              child: tripItems.length < 1
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("No trips found."),
                      ],
                    )
                  : ListView(
                      children: tripItems,
                    ),
            );
          },
        ),
      ],
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
