import 'package:alnabali_driver/src/constants/app_constants.dart';
import 'package:alnabali_driver/src/constants/app_styles.dart';
import 'package:alnabali_driver/src/features/trip/trip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TrackCard extends StatefulWidget {
  const TrackCard({
    Key? key,
    required this.info,
  }) : super(key: key);

  final Trip info;

  @override
  State<TrackCard> createState() => _TrackCardState();
}

class _TrackCardState extends State<TrackCard> {
  Widget buildTrackRow(
    BuildContext context,
    TripStatus st,
    Color clr,
    bool isLast,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Stack(
              alignment: AlignmentDirectional.center,
              children: [
                SizedBox(
                  width: 70.w,
                  child: Image.asset('assets/images/track_bg.png', color: clr),
                ),
                SizedBox(
                  width: 24.w,
                  child: Image.asset('assets/images/track_icon.png'),
                ),
              ],
            ),
            isLast
                ? const SizedBox()
                : Dash(
                    direction: Axis.vertical,
                    length: 80.h,
                    dashColor: clr,
                  ),
          ],
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getTabTitleFromID(st, context),
                  style: TextStyle(
                    color: kColorPrimaryBlue,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    fontSize: 30.sp,
                  ),
                ),
                SizedBox(height: 14.h),
                Text(
                  getTrackExplain(st, context),
                  style: TextStyle(
                    color: kColorPrimaryGrey,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    fontSize: 28.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 26.h),
          child: Text(
            '01:00 AM',
            style: TextStyle(
              color: kColorPrimaryBlue,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500,
              fontSize: 24.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildTracks(BuildContext context) {
    const dummyHistory = [
      TripStatus.pending,
      TripStatus.accepted,
      TripStatus.started,
      TripStatus.finished,
    ];

    final trackColor = getStatusColor(dummyHistory.last);
    List<Widget> widgetList = [];
    int i = 1;
    for (final st in dummyHistory) {
      widgetList.add(buildTrackRow(
        context,
        st,
        trackColor,
        i == dummyHistory.length,
      ));
      i++;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: widgetList,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 80.w, vertical: 120.h),
      padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 80.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.withOpacity(0.5)),
        borderRadius: BorderRadius.all(Radius.circular(40.w)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: buildTracks(context),
    );
  }
}
