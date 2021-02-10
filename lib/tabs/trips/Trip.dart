import 'package:daytrip/main.dart';
import 'package:daytrip/widgets/BasicTitle.dart';
import 'package:flutter/material.dart';

class Trip extends StatefulWidget {
  Trip({Key key}) : super(key: key);

  @override
  _TripState createState() => _TripState();
}

class _TripState extends State<Trip> {

  final _formKey = GlobalKey<FormState>();
  double _kilometreValue = 20;
  
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
          child: Column(
            children: <Widget>[
              // Trip Title TextField
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Enter a trip title',
                ),
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
                validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter trip description';
                }
                return null;
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
                divisions: 5,
                label: '$_kilometreValue',
                value: _kilometreValue,
                onChanged: (value){
                  setState(() {
                    _kilometreValue = value;       
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Validate will return true if the form is valid, or false if
                  // the form is invalid.
                  if (_formKey.currentState.validate()) {
                    // Process data.
                  }
                },
                child: Text('Save Trip'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
