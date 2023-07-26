import 'package:btdt/src/settings/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapView extends StatelessWidget {
  const MapView({
    super.key,
  });

  static const routeName = '/';


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
                child: FlutterMap(
                options: MapOptions(
                  center: const LatLng(51.509364, -0.128928),
                  zoom: 9.2,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://a.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}@2x.png',
                    userAgentPackageName: 'com.example.app',
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
