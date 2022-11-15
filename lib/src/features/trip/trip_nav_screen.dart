import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'package:alnabali_driver/src/constants/app_constants.dart';
import 'package:alnabali_driver/src/constants/app_styles.dart';
import 'package:alnabali_driver/src/features/trip/trip_controller.dart';
import 'package:alnabali_driver/src/features/trip/trip_nav_dialogs.dart';
import 'package:alnabali_driver/src/features/trip/trip.dart';
import 'package:alnabali_driver/src/widgets/dialogs.dart';
import 'package:alnabali_driver/src/widgets/progress_hud.dart';

class TripNavScreen extends ConsumerStatefulWidget {
  const TripNavScreen({
    super.key,
    required this.tripId,
  });

  final String tripId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NavigationScreenState();
}

class _NavigationScreenState extends ConsumerState<TripNavScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  late Trip info;

  LatLng orgLocation = const LatLng(37.4220656, -122.0840897);
  LatLng destLocation = const LatLng(37.4116103, -122.0713127);

  List<LatLng> polylineCoordinates = [];
  LocationData? currentLocation;

  BitmapDescriptor originIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;

  Timer? _updateTimer;

  Color _getPolyLineColor() {
    if (info.status == TripStatus.accepted) {
      return const Color(0xFFF7921D);
    } else if (info.status == TripStatus.started) {
      return const Color(0xFF1768D3);
    }
    return const Color(0xFF7B61FF);
  }

  void _getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyAVPD5PbpuYRB2m6OzcC3NtgNTh7Q0B-QA', // Your Google Map Key
      PointLatLng(orgLocation.latitude, orgLocation.longitude),
      PointLatLng(destLocation.latitude, destLocation.longitude),
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
      (newLoc) async {
        if (mounted == false) {
          return;
        }

        final zoom = await googleMapController.getZoomLevel();
        googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              zoom: zoom,
              target: LatLng(
                newLoc.latitude!,
                newLoc.longitude!,
              ),
            ),
          ),
        );
        setState(() {
          currentLocation = newLoc;
          //developer.log('onLocation = $currentLocation');
        });
      },
    );
  }

  void _setCustomMarkerIcon() {
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty, //(size: Size(98.w, 98.h)),
      "assets/images/route_src.png",
    ).then(
      (icon) {
        originIcon = icon;
      },
    );
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty, //(size: Size(77.w, 103.h)),
      "assets/images/route_dest.png",
    ).then(
      (icon) {
        destinationIcon = icon;
      },
    );
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty, //(size: Size(180.w, 181.h)),
      "assets/images/route_bus.png",
    ).then(
      (icon) {
        currentLocationIcon = icon;
      },
    );
  }

  @override
  void initState() {
    super.initState();

    info =
        ref.read(tripControllerProvider.notifier).getTripInfo(widget.tripId)!;

    _getPolyPoints();
    _getCurrentLocation();
    _setCustomMarkerIcon();

    _updateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      //developer.log('Location Update: ${timer.tick}');
      if (currentLocation != null) {
        final tripCtr = ref.read(tripControllerProvider.notifier);
        tripCtr.doUpdateLocation(
            currentLocation!.latitude!, currentLocation!.longitude!);
      }
    });
  }

  // * return distance in KM
  double _calcDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
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
    final state = ref.watch(tripControllerProvider);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: kBgDecoration,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 130.h, bottom: 60.h),
              child: Text(
                'TRIP #${widget.tripId}',
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
                  : ProgressHUD(
                      inAsyncCall: state.isLoading,
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: LatLng(currentLocation!.latitude!,
                              currentLocation!.longitude!),
                          zoom: 13.5,
                        ),
                        mapToolbarEnabled: false,
                        markers: {
                          Marker(
                            markerId: const MarkerId("source"),
                            position: orgLocation,
                            icon: originIcon,
                          ),
                          Marker(
                            markerId: const MarkerId("destination"),
                            position: destLocation,
                            icon: destinationIcon,
                          ),
                          Marker(
                            markerId: const MarkerId("currentLocation"),
                            anchor: const Offset(0.5, 0.5),
                            position: LatLng(currentLocation!.latitude!,
                                currentLocation!.longitude!),
                            icon: currentLocationIcon,
                            onTap: () {
                              double dist = 0;
                              if (info.status == TripStatus.accepted) {
                                dist = _calcDistance(
                                  currentLocation!.latitude!,
                                  currentLocation!.longitude!,
                                  orgLocation.latitude,
                                  orgLocation.longitude,
                                );
                                if (dist > 0.2) {
                                  showNavStatusDialog(context, info, false);
                                  return;
                                }
                              } else if (info.status == TripStatus.started) {
                                dist = _calcDistance(
                                  currentLocation!.latitude!,
                                  currentLocation!.longitude!,
                                  destLocation.latitude,
                                  destLocation.longitude,
                                );
                                if (dist > 0.2) {
                                  showNavStatusDialog(context, info, true);
                                  return;
                                }
                              }

                              showNavDialog(
                                context,
                                info,
                                (info, targetStatus, extra) {
                                  // ? this code duplicated with TripsListView...
                                  successCallback(value) {
                                    if (value == true) {
                                      showOkayDialog(
                                        context,
                                        info,
                                        targetStatus,
                                      ).then(
                                        (value) {
                                          if (targetStatus ==
                                                  TripStatus.rejected ||
                                              targetStatus ==
                                                  TripStatus.finished) {
                                            context.pop(); // go back.
                                          }
                                        },
                                      );
                                    }

                                    // * rebuild screen for card update.
                                    setState(() {
                                      info = ref
                                          .read(tripControllerProvider.notifier)
                                          .getTripInfo(widget.tripId)!;
                                    });
                                  }

                                  ref
                                      .read(tripControllerProvider.notifier)
                                      .doChangeTrip(info, targetStatus, extra)
                                      .then(successCallback);
                                },
                              );
                            },
                          ),
                        },
                        polylines: {
                          Polyline(
                            polylineId: const PolylineId("route"),
                            points: polylineCoordinates,
                            color: getStatusColor(info.status),
                            width: 6,
                          ),
                        },
                        onMapCreated: (mapController) {
                          _controller.complete(mapController);
                        },
                      ),
                    ),
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
