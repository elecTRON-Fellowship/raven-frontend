import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:raven/screens/places_results.dart';
import 'package:raven/widgets/common/end_drawer.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Position? position;
  late GoogleMapController _googleMapController;
  TextEditingController searchController = new TextEditingController();

  int _selectedNavBarIndex = 2;

  void _onIndexChanged(index, ctx) {
    setState(() {
      _selectedNavBarIndex = index;
      print(_selectedNavBarIndex);
    });
    if (_selectedNavBarIndex == 0) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/conversations', (r) => false);
      setState(() {
        _selectedNavBarIndex = 2;
      });
    }
    if (_selectedNavBarIndex == 1) {
      Navigator.of(context).pushReplacementNamed('/tickets');
      setState(() {
        _selectedNavBarIndex = 2;
      });
    }
    if (_selectedNavBarIndex == 3) {
      Scaffold.of(ctx).openEndDrawer();
      setState(() {
        _selectedNavBarIndex = 2;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getPosition();
  }

  @override
  void dispose() {
    super.dispose();
    _googleMapController.dispose();
  }

  void _getPosition() async {
    final result = await _determinePosition();
    setState(() {
      position = result;
      print(position!.latitude.toString());
      print(position!.latitude.toString());
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Set<Marker> _createMarker() {
    return <Marker>[
      Marker(
          markerId: MarkerId('home'),
          position: LatLng(position!.latitude, position!.longitude),
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(title: 'Current Location'))
    ].toSet();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final appBar = AppBar(
      elevation: 0.0,
      backgroundColor: theme.primaryColor,
      automaticallyImplyLeading: false,
      title: Text(
        'Places',
        style: GoogleFonts.poppins(
          textStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: theme.primaryColorDark,
          ),
        ),
      ),
    );
    return Scaffold(
      appBar: appBar,
      body: position != null
          ? Container(
              height: size.height - appBar.preferredSize.height,
              child: Stack(
                children: [
                  Container(
                      height: size.height - appBar.preferredSize.height,
                      child: GoogleMap(
                        onMapCreated: (controller) =>
                            _googleMapController = controller,
                        markers: _createMarker(),
                        myLocationButtonEnabled: false,
                        initialCameraPosition: CameraPosition(
                            target:
                                LatLng(position!.latitude, position!.longitude),
                            zoom: 16),
                      )),
                  Positioned(
                    top: 0,
                    left: size.width * 0.05,
                    child: Container(
                      width: size.width * 0.9,
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        onEditingComplete: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => PlacesResultsScreen(
                                searchString: searchController.text,
                                location:
                                    '${position!.latitude},${position!.longitude}',
                              ),
                            ),
                          );
                        },
                        controller: searchController,
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Theme.of(context).primaryColorDark,
                          ),
                        ),
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            color: Theme.of(context).primaryColorDark,
                          ),
                          fillColor: Theme.of(context).backgroundColor,
                          filled: true,
                          contentPadding: EdgeInsets.all(13),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColorDark,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColorDark,
                              width: 2,
                            ),
                          ),
                          hintText: "Search",
                          labelStyle: TextStyle(
                            color: Theme.of(context).primaryColorDark,
                          ),
                        ),
                        textCapitalization: TextCapitalization.words,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text(
                    'Getting your location...',
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: Theme.of(context).primaryColorDark)),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.accentColor,
        foregroundColor: theme.backgroundColor,
        onPressed: () {
          if (position != null)
            _googleMapController.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                    target: LatLng(position!.latitude, position!.longitude),
                    zoom: 16),
              ),
            );
        },
        child: Icon(Icons.center_focus_strong),
      ),
      endDrawer: EndDrawer(),
      bottomNavigationBar: Builder(
        builder: (ctx) => BottomNavigationBar(
          elevation: 2,
          currentIndex: _selectedNavBarIndex,
          onTap: (index) => _onIndexChanged(index, ctx),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          backgroundColor: theme.primaryColor,
          selectedItemColor: theme.primaryColorDark,
          unselectedItemColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.message_rounded,
                size: 30,
              ),
              label: 'Conversations',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.account_balance_wallet_rounded,
                size: 30,
              ),
              label: 'Tickets',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.map_rounded,
                size: 30,
              ),
              label: 'Uber',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.settings_rounded,
                size: 30,
              ),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
