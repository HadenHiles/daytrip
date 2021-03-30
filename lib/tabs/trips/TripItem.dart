import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daytrip/models/firestore/Trip.dart';
import 'package:daytrip/services/utility.dart';
import 'package:daytrip/tabs/trips/Trip.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:daytrip/tabs/Trips.dart';

class TripItem extends StatefulWidget {
  TripItem({Key key, this.trip, this.trips}) : super(key: key);

  final Trip trip;

  final Trips trips;

  @override
  _TripItemState createState() => _TripItemState();
}

class _TripItemState extends State<TripItem> {
  final user = FirebaseAuth.instance.currentUser;
  bool _tripSaved = false;

  _saveTrip(Trip trip) {
    // Add the trip id to the user's trips (saved_trips)
    FirebaseFirestore.instance.collection("trips").doc(user.uid).collection("saved_trips").doc(trip.reference.id).set({"trip_id": trip.reference.id, "date_saved": DateTime.now()}).then((stRef) {
      setState(() {
        _tripSaved = true;
      });

      print("Trip ${trip.reference.id} saved for user ${user.displayName}:${user.uid}.");
    }).catchError((error) {
      print("Error saving trip ${trip.reference.id} for user ${user.displayName}:${user.uid}.\n Error: $error");
    });
  }

  _unsaveTrip(Trip trip) {
    FirebaseFirestore.instance.collection("trips").doc(user.uid).collection('saved_trips').doc(trip.reference.id).delete().then((_) {
      setState(() {
        _tripSaved = false;
      });

      print("trips->${user.uid}->saved_trips->${trip.reference.id} deleted.");
    });
  }

  @override
  void initState() {
    FirebaseFirestore.instance.collection("trips").doc(user.uid).collection('saved_trips').where("trip_id", isEqualTo: widget.trip.reference.id).get().then((tRef) {
      setState(() {
        _tripSaved = tRef.docs.isNotEmpty;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.only(top: 0, right: 10, bottom: 0, left: 0),
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            child: IconButton(
              iconSize: 18,
              splashRadius: 20,
              padding: EdgeInsets.all(0),
              icon: Icon(
                Icons.bookmark,
                size: 18,
                color: _tripSaved ? Colors.red : Theme.of(context).colorScheme.onPrimary,
              ),
              onPressed: () {
                if (_tripSaved) {
                  _unsaveTrip(widget.trip);
                } else {
                  _saveTrip(widget.trip);
                }
              },
            ),
          ),
          Container(
            width: 85,
            height: 85,
            child: FittedBox(
              fit: BoxFit.fill,
              child: Image.network(widget.trip.imageURL),
            ),
          ),
        ],
      ),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.4,
                child: AutoSizeText(
                  widget.trip.title,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  minFontSize: 13,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            child: Text(printDuration(Duration(seconds: widget.trip.tripDuration), false)),
          ),
          Container(
            width: 200,
            child: AutoSizeText(
              widget.trip.description,
              style: TextStyle(
                fontSize: 12,
              ),
              minFontSize: 10,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          //Text(widget.trips.)
        ],
      ),
      trailing: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 8, left: 2, right: 2),
            child: InkWell(
              child: Icon(
                Icons.edit,
                size: 20,
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return TripDetail(
                    trip: widget.trip,
                  );
                }));
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 8, left: 2, right: 2),
            child: InkWell(
              child: Icon(
                Icons.delete,
                color: Colors.red,
                size: 20,
              ),
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: false, // user must tap button!
                  builder: (BuildContext context) {
                    return AlertDialog(
                      scrollable: true,
                      title: Text('Are you sure you want to delete?'),
                      content: Column(
                        children: [
                          Text('This trip cannot be recovered after deletion.'),
                          Text('Would you like to delete anyway?'),
                        ],
                      ),
                      actions: [
                        TextButton(
                          child: Text('Cancel'),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.primaryVariant),
                            foregroundColor: MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.onPrimary),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text('Delete'),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Theme.of(context).primaryColor,
                            ),
                          ),
                          onPressed: () {
                            FirebaseFirestore.instance.collection('trips').doc(user.uid).collection('trips').doc(widget.trip.reference.id).delete().then((value) {
                              final snackBar = SnackBar(content: Text('Trip deleted!'));
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            });

                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
