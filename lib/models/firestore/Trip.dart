import 'package:cloud_firestore/cloud_firestore.dart';

class Trip {
  String id;
  final String title;
  final DateTime date;
  final String description;
  final int tripDuration;
  final int tripDistance;
  DocumentReference reference;

  Trip(this.title, this.date, this.description, this.tripDuration,
      this.tripDistance);

  Trip.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['title'] != null),
        assert(map['date'] != null),
        assert(map['description'] != null),
        assert(map['trip_duration'] != null),
        assert(map['trip_distance'] != null),
        id = map['id'],
        title = map['title'],
        date = map['date'].toDate(),
        description = map['description'],
        tripDuration = map['trip_duration'],
        tripDistance = map['trip_distance'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'description': description,
      'trip_duration': tripDuration,
      'trip_distance': tripDistance
    };
  }

  Trip.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
