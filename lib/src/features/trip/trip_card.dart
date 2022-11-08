import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:alnabali_driver/src/constants/app_constants.dart';
import 'package:alnabali_driver/src/constants/app_styles.dart';
import 'package:alnabali_driver/src/features/trip/trip_busline.dart';
import 'package:alnabali_driver/src/features/trip/trip.dart';
import 'package:alnabali_driver/src/routing/app_router.dart';
import 'package:alnabali_driver/src/utils/string_hardcoded.dart';
import 'package:alnabali_driver/src/widgets/gradient_button.dart';
import 'package:alnabali_driver/src/widgets/dialogs.dart';

typedef TripCardCallback = void Function(String id, bool isYes, String? extra);

class TripCard extends StatefulWidget {
  const TripCard({
    Key? key,
    required this.info,
    required this.onPressed,
    required this.onYesNo,
    this.showDetail = false,
  }) : super(key: key);

  final Trip info;
  final VoidCallback onPressed;
  final TripCardCallback onYesNo;
  final bool showDetail;

  @override
  State<TripCard> createState() => _TripCardState();
}

class _TripCardState extends State<TripCard> {
  String _getStatusImgPath(TripStatus status) {
    return 'assets/images/trip_status${status.index}.png';
  }

  Widget _buildCompanyRow() {
    final avatarRadius = 60.h;

    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: kColorAvatarBorder, width: 1.0),
          ),
          child: CircleAvatar(
            radius: avatarRadius,
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
                  widget.info.clientName,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    fontSize: 32.sp,
                    color: kColorPrimaryGrey,
                  ),
                ),
                Text(
                  widget.info.tripName,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    fontSize: 26.sp,
                    color: getStatusColor(widget.info.status),
                  ),
                ),
              ],
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'BUS NO.'.hardcoded,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                fontSize: 24.sp,
                color: kColorPrimaryBlue,
              ),
            ),
            Text(
              widget.info.busNo,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                fontSize: 34.sp,
                color: kColorPrimaryBlue,
              ),
            ),
            Text(
              'Passengers'.hardcoded,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w500,
                fontSize: 24.sp,
                color: kColorPrimaryBlue,
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width: 38.w,
                  child: Image.asset('assets/images/passengers.png'),
                ),
                SizedBox(width: 8.w),
                Text(
                  widget.info.busSizeId.toString(),
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    fontSize: 34.sp,
                    color: kColorPrimaryBlue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRejectResonRow() {
    if (widget.info.status !=
        TripStatus.rejected /*|| widget.info.rejectReason.isEmpty*/) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 20.w, bottom: 4.h),
          child: Text(
            'REASON FOR REJECTION'.hardcoded,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600,
              fontSize: 12.sp,
              color: kColorPrimaryBlue,
            ),
          ),
        ),
        Text(
          'TODO: reject reason info support...', //info.rejectReason,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w400,
            fontSize: 12.sp,
            color: kColorSecondaryGrey,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          margin: EdgeInsets.only(top: 20.w, bottom: 4.h),
          child: Text(
            'DETAILS'.hardcoded,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600,
              fontSize: 32.sp,
              color: kColorPrimaryBlue,
            ),
          ),
        ),
        Text(
          widget.info.details,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w500,
            fontSize: 28.sp,
            color: kColorPrimaryGrey,
          ),
        ),
        _buildRejectResonRow(),
      ],
    );
  }

  Widget _buildButtonsRow() {
    if (widget.info.status == TripStatus.pending ||
        widget.info.status == TripStatus.accepted ||
        widget.info.status == TripStatus.started) {
      final btnW = 280.w;
      final btnH = 84.h;

      // as default, suppose status is pending
      String yesTitle = 'ACCEPT'.hardcoded;
      String noTitle = 'REJECT'.hardcoded;
      if (widget.info.status == TripStatus.accepted) {
        yesTitle = 'START'.hardcoded;
      } else if (widget.info.status == TripStatus.started) {
        yesTitle = 'FINISH'.hardcoded;
        noTitle = 'NAVIGATION'.hardcoded;
      }

      return SizedBox(
        height: btnH + 80.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: btnW,
              height: btnH,
              child: ElevatedButton(
                onPressed: () {
                  showConfirmDialog(
                    context,
                    widget.info.clientName,
                    widget.info.tripName,
                    widget.info.id,
                    widget.info.status,
                  ).then((value) {
                    if (value == true) {
                      widget.onYesNo(widget.info.id, true, null);
                    }
                  });
                },
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
              ),
            ),
            SizedBox(width: 8.w),
            GradientButton(
              width: btnW,
              height: btnH,
              onPressed: () {
                if (widget.info.status == TripStatus.started) {
                  // ? navigation to where???
                } else {
                  showRejectDialog(
                    context,
                    widget.info.clientName,
                    widget.info.tripName,
                    widget.info.id,
                  ).then((value) {
                    if (value != null) {
                      widget.onYesNo(widget.info.id, false, value);
                    }
                  });
                }
              },
              title: noTitle,
            ),
          ],
        ),
      );
    } else {
      return SizedBox(height: 40.h);
    }
  }

  Widget _buildCardContents() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 410.w,
              child: Image.asset(_getStatusImgPath(widget.info.status)),
            ),
            Text(
              widget.info.getStatusTitle(),
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w400,
                fontSize: 40.sp,
                color: Colors.white,
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: 2.h),
          child: Text(
            widget.info.getTripTitle(),
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500,
              fontSize: 36.sp,
              color: getStatusColor(widget.info.status),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 50.w),
          child: Column(
            children: [
              _buildCompanyRow(),
              SizedBox(height: 8.h),
              TripBusLine(info: widget.info),
              widget.showDetail ? _buildDetailRow() : const SizedBox(),
              _buildButtonsRow(),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.showDetail) return;

        context.goNamed(AppRoute.tripDetail.name);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 60.w),
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
        child: _buildCardContents(),
      ),
    );
  }
}
