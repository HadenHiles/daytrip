import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daytrip/main.dart';
import 'package:daytrip/services/utility.dart';
import 'package:daytrip/widgets/BasicTextField.dart';
import 'package:daytrip/widgets/BasicTitle.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:daytrip/models/firestore/Trip.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class TripDetail extends StatefulWidget {
  TripDetail({Key key, this.trip}) : super(key: key);

  final Trip trip;

  @override
  _TripDetailState createState() => _TripDetailState();
}

class _TripDetailState extends State<TripDetail> {
  final user = FirebaseAuth.instance.currentUser;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleTextFieldController = TextEditingController();
  final TextEditingController descriptionTextFieldController = TextEditingController();
  final TextEditingController addressTextFieldController = TextEditingController();
  final TextEditingController kilometersTextController = TextEditingController();
  final TextEditingController durationTextController = TextEditingController();

  // Used for image picker
  File _imageFile;
  final picker = ImagePicker();
  Widget button(String text, {Function onPressed, Color color}) {
    return Container(
      width: 200,
      height: 50,
      margin: EdgeInsets.symmetric(vertical: 5),
      color: color ?? Colors.redAccent,
      child: MaterialButton(
          child: Text(
            '$text',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: onPressed),
    );
  }

  String _imageURL;
  Future getImage() async {
    final _storage = FirebaseStorage.instance;
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() async {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
        String fileName = basename(_imageFile.path);
        var snapshot = await _storage.ref().child('tripImages/$fileName').putFile(_imageFile).onComplete;

        var downloadURL = await snapshot.ref.getDownloadURL();

        setState(() {
          _imageURL = downloadURL;
        });
      } else {
        print('No image selected.');
      }
    });
  }

  // Default values for kilometer and duration
  double _kilometerValue = 1.0;
  Duration _duration;
  String dateTime;

  //Used for the Cupterino Timer Picker
  Duration _initialtimer = new Duration();
  Future<void> bottomSheet(BuildContext context, Widget child, {double height}) {
    return showModalBottomSheet(isScrollControlled: false, shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(13), topRight: Radius.circular(13))), backgroundColor: Colors.white, context: context, builder: (context) => Container(height: height ?? MediaQuery.of(context).size.height / 3, child: child));
  }

  //Used for the Cupertino Time Picker
  Widget timePicker() {
    return CupertinoTimerPicker(
      mode: CupertinoTimerPickerMode.hm,
      minuteInterval: 15,
      initialTimerDuration: _initialtimer,
      onTimerDurationChanged: (Duration changedtimer) {
        setState(() {
          _initialtimer = changedtimer;
          _duration = changedtimer;
          durationTextController.text = printDuration(changedtimer, false);
        });
      },
    );
  }

  @override
  void initState() {
    if (widget.trip != null) {
      _imageURL = widget.trip.imageURL;
      titleTextFieldController.text = widget.trip.title;
      descriptionTextFieldController.text = widget.trip.description;
      addressTextFieldController.text = widget.trip.address;
      _duration = Duration(seconds: widget.trip.tripDuration);
      durationTextController.text = printDuration(Duration(seconds: widget.trip.tripDuration), false);
      kilometersTextController.text = widget.trip.tripDistance.toString();
      _kilometerValue = widget.trip.tripDistance.toDouble();
    }

    super.initState();
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
              actions: [
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: IconButton(
                    icon: Icon(
                      Icons.check,
                      size: 28,
                    ),
                    onPressed: () {
                      // Validate will return true if the form is valid, or false if
                      // the form is invalid.
                      if (_formKey.currentState.validate()) {
                        // Process data.
                        // Create trip object
                        Trip trip = Trip(
                          _imageURL,
                          titleTextFieldController.text.toString(),
                          DateTime.now(),
                          descriptionTextFieldController.text.toString(),
                          addressTextFieldController.text,
                          _duration.inSeconds,
                          double.tryParse(kilometersTextController.text).toInt(),
                        );

                        if (widget.trip == null) {
                          FirebaseFirestore.instance.collection('trips').doc(user.uid).collection('trips').add(trip.toMap()).then((value) {
                            navigatorKey.currentState.pop();
                          }).catchError((error) {
                            new SnackBar(content: new Text('Trip failed to save!'));
                          });
                        } else {
                          FirebaseFirestore.instance.collection('trips').doc(user.uid).collection('trips').doc(widget.trip.reference.id).update(trip.toMap()).then((value) {
                            navigatorKey.currentState.pop();
                          }).catchError((error) {
                            new SnackBar(content: new Text('Trip failed to save!'));
                          });
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ];
        },
        body: Container(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  // Image picker button to choose images
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: FloatingActionButton(
                      onPressed: getImage,
                      tooltip: 'Pick trip images here!',
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Icon(
                        Icons.add_a_photo,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  _imageURL == null ? Text('No image selected') : Image.network(_imageURL),

                  // Trip Title TextField
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: BasicTextField(
                      hintText: 'Enter a trip title',
                      controller: titleTextFieldController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a trip title';
                        }
                        return null;
                      },
                    ),
                  ),
                  // Description TextField
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: BasicTextField(
                      hintText: 'Enter a trip description',
                      controller: descriptionTextFieldController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter trip description';
                        }
                        return null;
                      },
                    ),
                  ),
                  // Address TextField
                  // I'm not sure how else we are storing the location, geolocation would be cool
                  // but will we complete that near the end, and just store it as an address for now? -TL
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: BasicTextField(
                      hintText: 'Please enter an address',
                      controller: addressTextFieldController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Valid address is needed';
                        }
                        return null;
                      },
                    ),
                  ),
                  // Creating a TextFormField that uses the number keyboard for ease of access.
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      cursorColor: Theme.of(context).textTheme.bodyText1.color,
                      style: Theme.of(context).textTheme.bodyText1,
                      decoration: InputDecoration(
                        hintStyle: Theme.of(context).textTheme.bodyText1,
                        hintText: 'How long is the trip? (in hours)',
                      ),
                      controller: durationTextController,
                      readOnly: true,
                      keyboardType: TextInputType.number,
                      validator: (String value) {
                        if (value == null) {
                          return 'A trip duration is needed';
                        }
                        return null;
                      },
                      onTap: () {
                        bottomSheet(context, timePicker());
                      },
                      onChanged: (String value) {
                        double minutes = double.tryParse(value);
                        setState(() {
                          if (minutes != null) {}
                        });
                      },
                    ),
                  ),
                  dateTime == null ? Container() : Text('$dateTime'),
                  // Creating a TextFormField that uses the number keyboard for ease of access.
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: TextFormField(
                      cursorColor: Theme.of(context).textTheme.bodyText1.color,
                      style: Theme.of(context).textTheme.bodyText1,
                      decoration: InputDecoration(
                        hintStyle: Theme.of(context).textTheme.bodyText1,
                        hintText: 'How far is the trip? (in kilometers)',
                      ),
                      readOnly: true,
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
                          if (kilometers != null) {
                            _kilometerValue = kilometers;
                          }
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: Theme.of(context).primaryColor,
                        inactiveTrackColor: Theme.of(context).colorScheme.primaryVariant,
                        trackShape: RectangularSliderTrackShape(),
                        trackHeight: 4.0,
                        thumbColor: Theme.of(context).colorScheme.secondary,
                        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                        overlayColor: Theme.of(context).primaryColor.withAlpha(32),
                        overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                      ),
                      child: Slider(
                        min: 0,
                        max: 100,
                        divisions: 100,
                        label: '$_kilometerValue',
                        value: _kilometerValue,
                        onChanged: (value) {
                          setState(() {
                            _kilometerValue = value.roundToDouble();
                          });
                          kilometersTextController.text = _kilometerValue.toString();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
