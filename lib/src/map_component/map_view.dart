import 'dart:developer';

import 'package:btdt/src/settings/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class MapView extends StatefulWidget {
  const MapView({
    super.key,
  });
  static const routeName = '/';
  @override
  State<MapView> createState()=> _MapViewState();
}
class _MapViewState extends State<MapView>{
  final Location location = Location();

  bool _loadingLocation = true;
  var currentLocation = const LatLng(51.509364, -0.128928);
  String? _error;

  Future<void> _getLocation() async{
    setState(() {
      _error = null;
    });
    try {
      location.enableBackgroundMode(enable: true);
      final locationResult = await location.getLocation();
      setState(() {
        currentLocation = LatLng(locationResult.latitude!, locationResult.longitude!);
        _loadingLocation = false;
      });
      location.onLocationChanged.listen((event) {
        setState(() {
          currentLocation = LatLng(event.latitude!, event.longitude!);
        });
      });
    } on PlatformException catch (err) {
      setState(() {
        _error = err.code;
        _loadingLocation = false;
      });
      log(_error!);
    }
  }
  @override
  void initState() {
    super.initState();
    _getLocation();
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 0, bottom: 0),
            ),
            Flexible(
                child: _loadingLocation == true ? const Center(child: Text("Loading...")) : FlutterMap(
                options: MapOptions(
                  center: currentLocation,
                  zoom: 9.2,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://a.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}@2x.png',
                    userAgentPackageName: 'com.example.app',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(point: currentLocation, builder:(context) => CircleAvatar())
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index){
          switch(index){
            case 2:{
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            }
            break;
          }
        },
        destinations: const <Widget>[
          NavigationDestination(icon: Icon(Icons.map), label: "Map"),
          NavigationDestination(icon: Icon(Icons.timeline), label: "History"),
          NavigationDestination(icon: Icon(Icons.settings), label: "settings")
        ],
      ),
    );
  }
}
