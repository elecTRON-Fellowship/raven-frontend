import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:raven/widgets/places_results_screen.dart/places_result_card.dart';
import 'package:uuid/uuid.dart';

class PlacesResultsScreen extends StatefulWidget {
  final String searchString;
  final String location;

  PlacesResultsScreen({required this.searchString, required this.location});

  @override
  _PlacesResultsScreenState createState() => _PlacesResultsScreenState();
}

class _PlacesResultsScreenState extends State<PlacesResultsScreen> {
  List places = [];

  void findPlace() async {
    var url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=AIzaSyA7JDmk8pXuhU5jm4l6YVhGxXk_fWpL2KY&keyword=${widget.searchString}&location=${widget.location}&rankby=distance');

    var res = await http.get(url);

    if (res.statusCode == 200) {
      var body = json.decode(res.body);
      setState(() {
        places = body['results'];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    findPlace();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    final appBar = AppBar(
      elevation: 0.0,
      backgroundColor: theme.primaryColor,
      title: Text(
        'Search Results',
        style: GoogleFonts.poppins(
            textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Theme.of(context).primaryColorDark)),
      ),
    );

    return Scaffold(
      appBar: appBar,
      body: ListView.builder(
        key: ValueKey(Uuid().v4()),
        itemCount: places.length,
        itemBuilder: (context, index) => PlacesResultCard(
          placeObject: places[index] as Map,
          origin: widget.location,
        ),
      ),
    );
  }
}
