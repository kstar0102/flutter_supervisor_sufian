import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:alnabali_driver/src/constants/app_styles.dart';
import 'package:alnabali_driver/src/features/trip/trip.dart';
import 'package:alnabali_driver/src/features/trip/trip_card.dart';

class TripDetailScreen extends StatefulWidget {
  TripDetailScreen({
    Key? key,
  }) : super(key: key);

  final info = Trip(
    id: '12345',
    status: TripStatus.accepted,
    clientName: 'client_name',
    tripName: 'trip_name',
    busNo: 'bus_no',
    busSizeId: 10,
    startDate: DateFormat('y-m-d h:mm a').parse('2022-02-02 2:20 AM'),
    endDate: DateFormat('y-m-d h:mm a').parse('2022-02-02 9:20 AM'),
    orgArea: 'origin_area',
    orgCity: 'origin_city',
    destArea: 'destination_area',
    destCity: 'destination_city',
    details: 'details',
  );

  @override
  State<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends State<TripDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: kBgDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              height: 80,
              child: Image.asset('assets/images/home_icon.png'),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(36),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      height: 573.h,
                      margin: EdgeInsets.symmetric(vertical: 60.h),
                      child: Image.asset('assets/images/trip_detail.png'),
                    ),
                    TripCard(
                      info: widget.info,
                      onPressed: () {},
                      showDetail: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: SizedBox(
          height: 150.h,
          child: IconButton(
            onPressed: () => context.pop(),
            //iconSize: 89.h,
            icon: Image.asset('assets/images/btn_back.png'),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    );
  }
}
