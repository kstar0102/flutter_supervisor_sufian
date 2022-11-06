import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:alnabali_driver/src/constants/app_styles.dart';
import 'package:alnabali_driver/src/features/trip/trip.dart';
import 'package:alnabali_driver/src/routing/app_router.dart';
import 'package:alnabali_driver/src/utils/string_hardcoded.dart';

class NotificationCard extends StatefulWidget {
  final Trip info;
  final VoidCallback onPressed;

  const NotificationCard({
    Key? key,
    required this.info,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(20.w);
    const textColor = Color(0xFF333333);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 80.w, vertical: 6.h),
      child: Wrap(
        alignment: WrapAlignment.end,
        children: [
          Container(
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  color: Colors.black54,
                  offset: Offset(0, 1),
                  blurRadius: 4.0,
                )
              ],
              borderRadius: borderRadius,
            ),
            child: Material(
              borderRadius: borderRadius,
              child: InkWell(
                borderRadius: borderRadius,
                onTap: () {
                  context.goNamed(AppRoute.tripDetail.name);
                },
                //splashColor: kColorPrimaryBlue.withOpacity(0.1),
                //splashFactory: InkSplash.splashFactory,
                child: Container(
                  height: 200.h,
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
                  child: Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircleAvatar(
                            radius: 50.h,
                            backgroundColor: widget.info.getStatusColor(),
                            child: Center(
                              child: Text(
                                "TRIP".hardcoded,
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 28.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            widget.info.getTripTitleShort(),
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500,
                              fontSize: 28.sp,
                              color: widget.info.getStatusColor(),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 50.w),
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.info.tripName,
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w700,
                                fontSize: 40.sp,
                                color: textColor,
                              ),
                            ),
                            Text(
                              widget.info.getNotifyText(),
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w500,
                                fontSize: 38.sp,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: Text(
              widget.info.getStartTimeStr(),
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                fontSize: 28.sp,
                color: kColorPrimaryGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
