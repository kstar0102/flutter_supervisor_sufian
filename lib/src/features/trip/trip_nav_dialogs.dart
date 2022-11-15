import 'dart:developer' as developer;
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:alnabali_driver/src/constants/app_constants.dart';
import 'package:alnabali_driver/src/constants/app_styles.dart';
import 'package:alnabali_driver/src/features/trip/trip.dart';
import 'package:alnabali_driver/src/utils/string_hardcoded.dart';
import 'package:alnabali_driver/src/widgets/dialogs.dart';
import 'package:alnabali_driver/src/widgets/gradient_button.dart';

Widget _buildCourseRow(Trip info) {
  final guideTextStyle = TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w700,
    fontSize: 24.sp,
    color: kColorPrimaryBlue,
  );
  final courseTextStyle = TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w700,
    fontSize: 26.sp,
    color: const Color(0xFF4C4C4C),
  );
  final cityTextStyle = TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w600,
    fontSize: 24.sp,
    color: const Color(0xFFB3B3B3),
  );

  return Row(
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ORIGIN LOCATION'.hardcoded, style: guideTextStyle),
          Text(info.orgArea, style: courseTextStyle),
          Text(info.orgCity, style: cityTextStyle),
        ],
      ),
      const Expanded(child: SizedBox()),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('DESTINATION LOCATION'.hardcoded, style: guideTextStyle),
          Text(info.destArea, style: courseTextStyle),
          Text(info.destCity, style: cityTextStyle),
        ],
      ),
    ],
  );
}

Widget _buildDistTimeRow(double dist, double time) {
  final guideStyle = TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w700,
    fontSize: 24.sp,
    color: kColorPrimaryBlue,
  );
  final valueStyle = TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w700,
    fontSize: 34.sp,
    color: Colors.black54,
  );

  return Row(
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Distance'.hardcoded, style: guideStyle),
          RichText(
            text: TextSpan(
              style: valueStyle,
              children: [
                TextSpan(text: '$dist'),
                TextSpan(
                  text: ' km',
                  style:
                      TextStyle(fontWeight: FontWeight.w600, fontSize: 28.sp),
                ),
              ],
            ),
          ),
        ],
      ),
      SizedBox(width: 50.w),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Time'.hardcoded, style: guideStyle),
          RichText(
            text: TextSpan(
              style: valueStyle,
              children: [
                TextSpan(text: '$time'),
                TextSpan(
                  text: ' min',
                  style:
                      TextStyle(fontWeight: FontWeight.w600, fontSize: 28.sp),
                ),
              ],
            ),
          ),
        ],
      ),
    ],
  );
}

typedef NavDialogCallback = void Function(
    TripStatus targetStatus, String? extra);

Future<void> showNavDialog(
    BuildContext context, Trip info, NavDialogCallback onYesNo) {
  final btnW = 280.w;
  final btnH = 84.h;

  String yesTitle = 'unknown';
  if (info.status == TripStatus.accepted) {
    yesTitle = 'START TRIP'.hardcoded;
  } else if (info.status == TripStatus.started) {
    yesTitle = 'FINISH TRIP'.hardcoded;
  }

  return showDialog<void>(
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0),
    context: context,
    builder: (context) {
      return AlertDialog(
        alignment: Alignment.bottomCenter,
        elevation: 8,
        insetPadding: EdgeInsets.all(20.w),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(40.h))),
        titlePadding: EdgeInsets.only(left: 50.w, top: 40.h, right: 30.w),
        title: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: kColorAvatarBorder, width: 1.0),
              ),
              child: CircleAvatar(
                radius: 60.h,
                backgroundColor: Colors.transparent,
                backgroundImage:
                    const AssetImage('assets/images/company_mcdonald\'s.png'),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 10.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      info.clientName,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                        fontSize: 32.sp,
                        color: kColorPrimaryGrey,
                      ),
                    ),
                    Text(
                      info.tripName,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500,
                        fontSize: 26.sp,
                        color: getStatusColor(info.status),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
        content: SizedBox(
          width: ScreenUtil().screenWidth - 40.w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Divider(color: Colors.black38),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 12.h),
                      decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: kColorPrimaryBlue)),
                      ),
                      child: Row(
                        children: [
                          Image(
                            width: 150.w,
                            image:
                                const AssetImage('assets/images/bus_from.png'),
                          ),
                          const Expanded(child: SizedBox()),
                          Image(
                            width: 50.w,
                            image: const AssetImage('assets/images/bus_to.png'),
                          ),
                        ],
                      ),
                    ),
                    _buildCourseRow(info),
                    SizedBox(height: 20.h),
                    _buildDistTimeRow(40, 15),
                  ],
                ),
              ),
              const Divider(color: Colors.black38),
            ],
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actionsPadding: EdgeInsets.only(bottom: 40.h),
        actions: [
          GradientButton(
            width: btnW,
            height: btnH,
            title: 'REJECT'.hardcoded,
            onPressed: () {
              Navigator.pop(context, false);

              showRejectDialog(
                context,
                info.clientName,
                info.tripName,
                info.id,
              ).then((value) {
                if (value != null) {
                  onYesNo(TripStatus.rejected, value);
                }
              });
            },
          ),
          SizedBox(
            width: btnW,
            height: btnH,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kColorPrimaryBlue,
                shape: const StadiumBorder(),
              ),
              child: Text(
                yesTitle,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  fontSize: 26.sp,
                ),
              ),
              onPressed: () {
                Navigator.pop(context, true);

                showConfirmDialog(
                  context,
                  info.clientName,
                  info.tripName,
                  info.id,
                  info.status,
                ).then((value) {
                  if (value == true) {
                    TripStatus targetStatus = TripStatus.all;
                    if (info.status == TripStatus.pending) {
                      targetStatus = TripStatus.accepted;
                    } else if (info.status == TripStatus.accepted) {
                      targetStatus = TripStatus.started;
                    } else if (info.status == TripStatus.started) {
                      targetStatus = TripStatus.finished;
                    } else {
                      developer.log('TripCard: unknown state change...');
                      return;
                    }
                    onYesNo(targetStatus, null);
                  }
                });
              },
            ),
          ),
        ],
      );
    },
  );
}

Future<void> showNavStatusDialog(
    BuildContext context, Trip info, bool isGoDest) {
  return showDialog(
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0),
    context: context,
    builder: (context) {
      return AlertDialog(
        alignment: Alignment.bottomCenter,
        elevation: 8,
        insetPadding: EdgeInsets.all(20.w),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(40.h))),
        titlePadding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 40.h),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: kColorAvatarBorder, width: 1.0),
              ),
              child: CircleAvatar(
                radius: 60.h,
                backgroundColor: Colors.transparent,
                backgroundImage:
                    const AssetImage('assets/images/company_mcdonald\'s.png'),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    info.clientName,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      fontSize: 32.sp,
                      color: kColorPrimaryGrey,
                    ),
                  ),
                  Text(
                    info.tripName,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      fontSize: 26.sp,
                      color: getStatusColor(info.status),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(child: SizedBox(width: 300.w)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Going to'.hardcoded,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                    fontSize: 32.sp,
                    color: kColorPrimaryGrey,
                  ),
                ),
                Text(
                  isGoDest
                      ? 'Destination Location'.hardcoded
                      : 'Origin Location'.hardcoded,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                    fontSize: 32.sp,
                    color: kColorPrimaryGrey,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}