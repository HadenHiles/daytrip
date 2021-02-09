import 'package:cloud_firestore/cloud_firestore.dart';

class Trip {
  String id;
  final String title;
  final String description;
  DocumentReference reference;

  Trip(this.title, this.description);

  Trip.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['title'] != null),
        assert(map['description'] != null),
        id = map['id'],
        title = map['title'],
        description = map['description'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
    };
  }

  Trip.fromSnapshot(DocumentSnapshot snapshot) : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
