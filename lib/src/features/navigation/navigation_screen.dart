import 'dart:async';
import 'package:flutter/material.dart';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class NavigationScreen extends ConsumerStatefulWidget {
  const NavigationScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NavigationScreenState();
}

class _NavigationScreenState extends ConsumerState<NavigationScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  static const LatLng sourceLocation = LatLng(37.335, -122.032);
  static const LatLng destLocation = LatLng(37.335, -122.070);

  List<LatLng> polylineCoordinates = [];
  LocationData? currentLocation;

  @override
  void initState() {
    super.initState();

    getCurrentLocation();
    getPolyPoints();
  }

  void getCurrentLocation() {
    Location location = Location();
    location.getLocation().then(
          (value) => currentLocation = value,
        );
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        'AIzaSyBgmDKTs8cHeDgOG-Srw76Yac8vNFUcXPc',
        PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
        PointLatLng(destLocation.latitude, destLocation.longitude));
    //print(result);

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.terrain,
      initialCameraPosition:
          const CameraPosition(target: sourceLocation, zoom: 13),
      markers: {
        const Marker(markerId: MarkerId("source"), position: sourceLocation),
        const Marker(markerId: MarkerId("destination"), position: destLocation),
      },
      polylines: {
        Polyline(
            polylineId: const PolylineId('route'),
            points: polylineCoordinates,
            color: Colors.purple,
            width: 6)
      },
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    );
  }
}
