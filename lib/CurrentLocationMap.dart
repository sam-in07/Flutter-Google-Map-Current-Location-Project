import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CurrentLocationMap extends StatefulWidget {
  const CurrentLocationMap({super.key});

  @override
  State<CurrentLocationMap> createState() => _CurrentLocationMapState();
}

class _CurrentLocationMapState extends State<CurrentLocationMap> {
  // Google Map Controller
  GoogleMapController? map;
  // ? for if map load hoi nai....
  //posotion change jonno nao hoite pare ?
  StreamSubscription<Position>? sub;
  // ami busy na loc  oita detect
  LatLng? myself;
  //
  final markerId=MarkerId("Samin");
// Initial Location
  @override




  @override
  Widget build(BuildContext context) {
    final start=myself ?? const LatLng(23.777176, 90.399452);
    final marker={
      Marker(
          markerId: markerId,
          position: myself!,
          infoWindow: InfoWindow(title: "Samin")
      ),
    };

    return Scaffold(
      appBar: AppBar(
        title: Text("Current Location"),
      ),
        body: Stack(
          children: [
            GoogleMap(

                initialCameraPosition: CameraPosition(target: start,zoom: 14),
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                markers: marker ,
            )
          ],
        )
    );
  }




}