import 'package:daytrip/models/firestore/Trip.dart';
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
  @override
  Widget build(BuildContext context) {
    return ListTile(
      //Once we can store our pictures in Firebase, we can uncomment
      //and then our trips will start with the picture
      /*leading: Image.network(
                        trip.
                        height: 50,
                        width: 75,
                      ),*/
      title: Text(widget.trip.title),
      subtitle: Column(children: [
        Container(
          child: Text(widget.trip.date.toString()),
        ),
        Container(
          child: Text(widget.trip.description),
        ),
        //Text(widget.trips.)
      ]),
      trailing: Text(widget.trip.tripDistance.toString()),
    );
  }
}
