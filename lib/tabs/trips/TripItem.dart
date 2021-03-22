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

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(
        widget.trip.imageURL,
        height: 50,
        width: 75,
      ),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(widget.trip.title),
            ],
          ),
          Flexible(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  child: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                        return TripDetail(
                          trip: widget.trip,
                        );
                      }));
                    },
                  ),
                ),
                Container(
                  child: IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () {
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
            child: Text(widget.trip.description),
          ),
          //Text(widget.trips.)
        ],
      ),
    );
  }
}
