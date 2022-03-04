import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';




// class MapSample extends StatefulWidget {
//   const MapSample({Key? key}) : super(key: key);
//
//   @override
//   State<MapSample> createState() => MapSampleState();
// }
//
// class MapSampleState extends State<MapSample> {
//   final Completer<GoogleMapController> _controller = Completer();
//
//   static final CameraPosition _kGooglePlex =   CameraPosition(
//     target: LatLng(37.42796133580664, -122.085749655962),
//     zoom: 14.4746,
//   );
//
//   static final CameraPosition _kLake = CameraPosition(
//       bearing: 192.8334901395799,
//       target: LatLng(37.43296265331129, -122.08832357078792),
//       tilt: 59.440717697143555,
//       zoom: 19.151926040649414);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GoogleMap(
//         mapType: MapType.hybrid,
//         initialCameraPosition: _kGooglePlex,
//         onMapCreated: (GoogleMapController controller) {
//           _controller.complete(controller);
//         },
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: _goToTheLake,
//         label: const Text('To the lake!'),
//         icon: const Icon(Icons.directions_boat),
//       ),
//     );
//   }
//
//   Future<void> _goToTheLake() async {
//     final GoogleMapController controller = await _controller.future;
//     controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
//   }
// }


class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  GoogleMapController? _controller;
  Location currentLocation=Location();
  final List<Marker> markers = [];




  void getLocation() async{
    var location = await currentLocation.getLocation();
    currentLocation.onLocationChanged.listen((LocationData loc){

      _controller?.animateCamera(CameraUpdate.newCameraPosition( CameraPosition(
        target: LatLng(loc.latitude ?? 0.0,loc.longitude?? 0.0),
        zoom: 19.0,
      )));
      print(loc.latitude);
      print(loc.longitude);
      markers.add(Marker(markerId: MarkerId('Office'),
          position: LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0)
      ));
      setState(() {

      });
    });
  }
  addMarker(cordinate){

    int id = Random().nextInt(100);

    setState(() {
      markers.add(Marker(position: cordinate, markerId: MarkerId(id.toString())));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        myLocationEnabled: true,
        mapType: MapType.hybrid,
        zoomControlsEnabled: true,
        initialCameraPosition: const CameraPosition(
          target: LatLng(48.8561, 2.2930),
            zoom: 19.151926040649414
        ),

        onMapCreated: (GoogleMapController controller){
          _controller = controller;
        },
        markers: markers.toSet(),
        onTap: (cordinate){
          _controller?.animateCamera(CameraUpdate.newLatLng(cordinate));
          addMarker(cordinate);
        },
      ) ,

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.location_searching,color: Colors.white,),
        onPressed: (){
          getLocation();
        },
      ),
    );
  }
}
