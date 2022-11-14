import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'package:alnabali_driver/src/constants/app_styles.dart';
import 'package:alnabali_driver/src/features/auth/auth_controllers.dart';

class NavigationScreen extends ConsumerStatefulWidget {
  const NavigationScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NavigationScreenState();
}

class _NavigationScreenState extends ConsumerState<NavigationScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  static const LatLng sourceLocation = LatLng(37.4220656, -122.0840897);
  static const LatLng destination = LatLng(37.4116103, -122.0713127);

  List<LatLng> polylineCoordinates = [];
  LocationData? currentLocation;

  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;

  Timer? _updateTimer;

  void _getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyDex_ZN1s9cNPkU4VCjtE9OmTHBQeZzOWM', // Your Google Map Key
      PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        );
      }
      setState(() {});
    }
  }

  void _getCurrentLocation() async {
    Location location = Location();
    location.getLocation().then(
      (location) {
        if (mounted == false) {
          return false;
        }
        //currentLocation = location;
        setState(() {
          currentLocation = location;
        });
      },
    );

    GoogleMapController googleMapController = await _controller.future;
    location.onLocationChanged.listen(
      (newLoc) {
        if (mounted == false) {
          return;
        }

        //currentLocation = newLoc;
        googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              zoom: 13.5,
              target: LatLng(
                newLoc.latitude!,
                newLoc.longitude!,
              ),
            ),
          ),
        );
        setState(() {
          currentLocation = newLoc;
        });
      },
    );
  }

  void _setCustomMarkerIcon() {
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(98.w, 98.h)),
            "assets/images/route_src.png")
        .then(
      (icon) {
        sourceIcon = icon;
      },
    );
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(77.w, 103.h)),
            "assets/images/route_dest.png")
        .then(
      (icon) {
        destinationIcon = icon;
      },
    );
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(180.w, 181.h)),
            "assets/images/bus_to.png")
        .then(
      (icon) {
        currentLocationIcon = icon;
      },
    );
  }

  @override
  void initState() {
    super.initState();

    _getPolyPoints();
    _getCurrentLocation();
    _setCustomMarkerIcon();

    _updateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      developer.log('Location Update: ${timer.tick}');
      if (currentLocation != null) {
        final loginCtr = ref.read(loginControllerProvider.notifier);
        loginCtr.doUpdateLocation(
            currentLocation!.latitude!, currentLocation!.longitude!);
      }
    });
  }

  @override
  void dispose() {
    if (_updateTimer != null) {
      _updateTimer!.cancel();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: kBgDecoration,
        child: Stack(
          children: [
            // MapWidget
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 130.h, bottom: 60.h),
                  child: Text(
                    'TRIP #123456',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w800,
                      fontSize: 50.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  child: currentLocation == null
                      ? const Center(child: CircularProgressIndicator())
                      : GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: LatLng(currentLocation!.latitude!,
                                currentLocation!.longitude!),
                            zoom: 13.5,
                          ),
                          markers: {
                            Marker(
                              markerId: const MarkerId("source"),
                              position: sourceLocation,
                              icon: sourceIcon,
                            ),
                            Marker(
                              markerId: const MarkerId("destination"),
                              position: destination,
                              icon: destinationIcon,
                            ),
                            Marker(
                              markerId: const MarkerId("currentLocation"),
                              position: LatLng(currentLocation!.latitude!,
                                  currentLocation!.longitude!),
                              icon: currentLocationIcon,
                            ),
                          },
                          polylines: {
                            Polyline(
                              polylineId: const PolylineId("route"),
                              points: polylineCoordinates,
                              color: const Color(0xFF7B61FF),
                              width: 6,
                            ),
                          },
                          onMapCreated: (mapController) {
                            _controller.complete(mapController);
                          },
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(top: 20.h),
        child: SizedBox(
          height: 138.h,
          child: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: Image.asset('assets/images/btn_back.png'),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    );
  }
}
