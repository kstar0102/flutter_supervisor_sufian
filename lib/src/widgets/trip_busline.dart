import 'package:alnabali_driver/src/features/trip/data/trip_info.dart';
import 'package:flutter/material.dart';

import 'package:alnabali_driver/src/widgets/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TripBusLine extends StatefulWidget {
  final BusLineInfo info;

  const TripBusLine({
    Key? key,
    required this.info,
  }) : super(key: key);

  @override
  State<TripBusLine> createState() => _TripBusLineState();
}

class _TripBusLineState extends State<TripBusLine> {
  Widget _buildTimeLineRow() {
    final dateTextStyle = TextStyle(
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.w600,
      fontSize: 26.sp,
      color: kColorSecondaryGrey,
    );
    final timeTextStyle = TextStyle(
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.w600,
      fontSize: 22.sp,
      color: kColorPrimaryBlue,
    );

    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.info.getFromDateStr(),
              style: dateTextStyle,
            ),
            Text(
              widget.info.getFromTimeStr(),
              style: timeTextStyle,
            ),
          ],
        ),
        const Expanded(child: SizedBox()),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.info.getToDateStr(),
              style: dateTextStyle,
            ),
            Text(
              widget.info.getToTimeStr(),
              style: timeTextStyle,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBusRow() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: kColorPrimaryBlue),
        ),
      ),
      child: Row(
        children: [
          Image(
            width: 150.w,
            image: const AssetImage('assets/images/bus_from.png'),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Image(
                  width: 25.w,
                  image: const AssetImage('assets/images/bus_time.png'),
                ),
                const SizedBox(width: 2),
                Text(
                  widget.info.getDurTimeStr(),
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    fontSize: 22.sp,
                    color: kColorPrimaryBlue,
                  ),
                ),
              ],
            ),
          ),
          Image(
            width: 50.w,
            image: const AssetImage('assets/images/bus_to.png'),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseRow() {
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
            Text(
              widget.info.courseName,
              style: courseTextStyle,
            ),
            Text(
              widget.info.cityName,
              style: cityTextStyle,
            ),
          ],
        ),
        const Expanded(child: SizedBox()),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.info.courseName,
              style: courseTextStyle,
            ),
            Text(
              widget.info.cityName,
              style: cityTextStyle,
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black.withOpacity(0.6),
          width: 1,
        ),
        borderRadius: BorderRadius.all(Radius.circular(20.w)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Column(
        children: [
          _buildTimeLineRow(),
          SizedBox(height: 10.h),
          _buildBusRow(),
          SizedBox(height: 10.h),
          _buildCourseRow(),
        ],
      ),
    );
  }
}
