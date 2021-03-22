import 'package:cloud_firestore/cloud_firestore.dart';

class Trip {
  String id;
  final String title;
  final DateTime date;
  final String description;
  final String address;
  final int tripDuration;
  final int tripDistance;
  final String imageURL;
  DocumentReference reference;

  Trip(this.imageURL, this.title, this.date, this.description, this.address, this.tripDuration, this.tripDistance);

  Trip.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['imageURL'] != null),
        assert(map['title'] != null),
        assert(map['date'] != null),
        assert(map['description'] != null),
        assert(map['address'] != null),
        assert(map['trip_duration'] != null),
        assert(map['trip_distance'] != null),
        id = map['id'],
        imageURL = map['imageURL'],
        title = map['title'],
        date = map['date'].toDate(),
        description = map['description'],
        address = map['address'],
        tripDuration = map['trip_duration'],
        tripDistance = map['trip_distance'];

  Map<String, dynamic> toMap() {
    return {'id': id, 'imageURL': imageURL, 'title': title, 'date': date, 'description': description, 'address': address, 'trip_duration': tripDuration, 'trip_distance': tripDistance};
  }

  Trip.fromSnapshot(DocumentSnapshot snapshot) : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
