import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daytrip/main.dart';
import 'package:daytrip/widgets/BasicTitle.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:daytrip/models/firestore/Trip.dart';

class AddTrip extends StatefulWidget {
  AddTrip({Key key}) : super(key: key);

  @override
  _AddTripState createState() => _AddTripState();
}

class _AddTripState extends State<AddTrip> {

  final user = FirebaseAuth.instance.currentUser;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleTextFieldController = TextEditingController();
  final TextEditingController descriptionTextFieldController = TextEditingController();
  final TextEditingController kilometersTextController = TextEditingController();
  final TextEditingController durationTextController = TextEditingController();
  
  // Used for image picker
  File _image;
  final picker = ImagePicker();
  
  // Default values for kilometer and duration
  double _kilometerValue = 1.0;
  double _durationValue = 1.0;

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              collapsedHeight: 65,
              expandedHeight: 65,
              backgroundColor: Theme.of(context).colorScheme.primary,
              floating: true,
              pinned: true,
              leading: Container(
                margin: EdgeInsets.only(top: 10),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: 28,
                  ),
                  onPressed: () {
                    navigatorKey.currentState.pop();
                  },
                ),
              ),
              flexibleSpace: DecoratedBox(
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                ),
                child: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  titlePadding: null,
                  centerTitle: false,
                  title: BasicTitle(title: "Add Trip"),
                  background: Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                ),
              ),
              actions: [],
            ),
          ];
        },
        body: Container(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                _image == null
                ? Text('No image selected')
                : Image.file(_image),
              
                // Trip Title TextField
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Enter a trip title',
                ),
                controller: titleTextFieldController,
                validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter a trip title';
                }
                return null;
              },
            ),
            // Description TextField
            TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Enter a trip description',
                ),
                controller: descriptionTextFieldController,
                validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter trip description';
                }
                return null;
              },
            ),
            // Address TextField
            // I'm not sure how else we are storing the location, geolocation would be cool
            // but will we complete that near the end, and just store it as an address for now? -TL
            TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Please enter an address',
                ),
                validator: (value) {
                if (value.isEmpty) {
                  return 'Valid address is needed';
                }
                return null;
              },
            ),
            // Creating a TextFormField that uses the number keyboard for ease of access.
            TextFormField(
                decoration: const InputDecoration(
                  hintText: 'How long is the trip? (in minutes?)',
                ),
                controller: durationTextController,
                keyboardType: TextInputType.number,
                validator: (String value) {

                  double minutes = double.tryParse(value);

                if (minutes == null) {
                  return 'Correct trip duration is needed';
                }
                return null;
              },
              onChanged: (String value) {
                double minutes = double.tryParse(value);
                setState(() {
                  if (minutes != null){
                  _durationValue = minutes;
                  }               
                });
              },
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: Colors.green[700],
                inactiveTrackColor: Colors.transparent,
                trackShape: RectangularSliderTrackShape(),
                trackHeight: 4.0,
                thumbColor: Colors.lightGreenAccent,
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                overlayColor: Colors.lightGreen.withAlpha(32),
                overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
            ),
              child: Slider.adaptive(
                min: 0,
                max: 100,
                divisions: 100,
                label: '$_durationValue',
                value: _durationValue,
                onChanged: (value){
                  setState(() {
                    _durationValue = value.roundToDouble(); 
                  });
                  durationTextController.text = _durationValue.toString();
                },
              ),
            ),
            // Creating a TextFormField that uses the number keyboard for ease of access.
            TextFormField(
                decoration: const InputDecoration(
                  hintText: 'How far is the trip? (in kilometers)',
                ),
                controller: kilometersTextController,
                keyboardType: TextInputType.number,
                validator: (String value) {

                  double kilometers = double.tryParse(value);

                if (kilometers == null) {
                  return 'Correct trip length is needed';
                }
                return null;
              },
              onChanged: (String value) {
                double kilometers = double.tryParse(value);
                setState(() {
                  if (kilometers != null){
                  _kilometerValue = kilometers;
                  }               
                });
              },
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: Colors.green[700],
                inactiveTrackColor: Colors.transparent,
                trackShape: RectangularSliderTrackShape(),
                trackHeight: 4.0,
                thumbColor: Colors.lightGreenAccent,
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                overlayColor: Colors.lightGreen.withAlpha(32),
                overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
            ),
              child: Slider(
                min: 0,
                max: 100,
                divisions: 100,
                label: '$_kilometerValue',
                value: _kilometerValue,
                onChanged: (value){
                  setState(() {
                    _kilometerValue = value.roundToDouble();       
                  });
                  kilometersTextController.text = _kilometerValue.toString();
                },
              ),
            ),
            // Image picker button to choose images
            FloatingActionButton(
            onPressed: getImage,
            tooltip: 'Pick trip images here!',
            child: Icon(Icons.add_a_photo),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Validate will return true if the form is valid, or false if
                  // the form is invalid.
                  if (_formKey.currentState.validate()) {
                    // Process data.
                    // Create trip object
                    Trip trip = Trip(
                      titleTextFieldController.text.toString(), 
                      DateTime.now(), 
                      descriptionTextFieldController.text.toString(),
                      Duration(hours: 3).inSeconds,
                      double.tryParse(kilometersTextController.text).toInt()
                    );

                    FirebaseFirestore.instance.collection('trips').doc(user.uid).collection('trips').add(trip.toMap()).then((value) {
                      navigatorKey.currentState.pop();
                    }).catchError((error){
                      new SnackBar(content: new Text('Trip not added successfully!'));
                    });
                    }
                      FirebaseFirestore.instance.collection('trips').doc(user.uid).collection('trips').snapshots();
                  },
                    child: Text('Save Trip'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
