import 'package:daytrip/models/firestore/Trip.dart';
import 'package:daytrip/services/utility.dart';
import 'package:daytrip/tabs/trips/Trip.dart';
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
      leading: Image.network(
        widget.trip.imageURL,
        height: 50,
        width: 75,
      ),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.trip.title),
          Text(widget.trip.tripDistance.toString() + " km"),
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
      trailing: IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return TripDetail(
              trip: widget.trip,
            );
          }));
        },
      ),
    );
  }
}
