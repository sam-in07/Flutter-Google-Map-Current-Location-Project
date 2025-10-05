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
  void initState(){
    super.initState();
    initLocation();
  }



  Future<void> initLocation()  async {


    // 01 Permission Manage
    LocationPermission permission=await Geolocator.checkPermission();
    if(permission==LocationPermission.denied){
      permission=await Geolocator.requestPermission();
    }

    if(permission==LocationPermission.denied || permission==LocationPermission.deniedForever){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Location Permission Misssing"))
      );
      return;
    }

    // 02 Ensure Location Services On
    final enabled=await Geolocator.isLocationServiceEnabled();
    if(!enabled){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please Enable Location Services"))
      );
      return;
    }

    // 03 Intial Position

    final pos= await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    updatePosition(pos);



    // Stream updates
    sub?.cancel();
    sub=Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best,
          distanceFilter: 5
      ),
    ).listen((p)=>updatePosition(p));


  }


  // Update Position

  void  updatePosition(Position p){
    final here = LatLng(p.latitude, p.longitude);
    setState(() {
      myself=here;
    });
    animateTo(here);
  }


  Future<void>  animateTo(LatLng target) async{
    if(map==null) return;
    await map!.animateCamera(
        CameraUpdate.newCameraPosition(
            CameraPosition(target: target,zoom: 14)
        )
    );
  }




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