import 'package:alnabali_driver/src/constants/app_sizes.dart';
import 'package:alnabali_driver/src/features/trip/data/trip_info.dart';
import 'package:alnabali_driver/src/routing/app_router.dart';
import 'package:alnabali_driver/src/utils/string_hardcoded.dart';
import 'package:flutter/material.dart';

import 'package:alnabali_driver/src/widgets/constants.dart';
import 'package:alnabali_driver/src/widgets/trip_busline.dart';
import 'package:alnabali_driver/src/widgets/gradient_button.dart';
import 'package:alnabali_driver/src/widgets/dialogs.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class TripCard extends StatefulWidget {
  final TripInfo info;
  final VoidCallback onPressed;
  final bool showDetail;

  const TripCard({
    Key? key,
    required this.info,
    required this.onPressed,
    this.showDetail = false,
  }) : super(key: key);

  @override
  State<TripCard> createState() => _TripCardState();
}

class _TripCardState extends State<TripCard> {
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
                AssetImage(widget.info.company.getCompanyImgPath()),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.info.company.companyName,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    fontSize: 32.sp,
                    color: kColorPrimaryGrey,
                  ),
                ),
                Text(
                  widget.info.company.tripName,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    fontSize: 26.sp,
                    color: widget.info.getStatusColor(),
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
                  widget.info.passengers.toString(),
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
    if (widget.info.status != TripStatus.rejected ||
        widget.info.rejectReason.isEmpty) return const SizedBox();

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
          widget.info.rejectReason,
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
          widget.info.busLine.courseDetail,
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
      String yesTitle = 'ACCEPT'.hardcoded;
      String noTitle = 'REJECT'.hardcoded;
      if (widget.info.status == TripStatus.started) {
        yesTitle = 'FINISH'.hardcoded;
        noTitle = 'NAVIGATION'.hardcoded;
      } else if (widget.info.status == TripStatus.accepted) {
        yesTitle = 'START'.hardcoded;
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
                  showAcceptFinishDialog(
                    context,
                    widget.info.company.companyName,
                    widget.info.company.tripName,
                    widget.info.tripNo,
                    widget.info.status == TripStatus.pending,
                  ).then((value) {
                    if (value!) {
                      if (widget.info.status == TripStatus.pending) {
                        // accepting action...
                        showOkayDialog(
                          context,
                          widget.info.company.companyName,
                          widget.info.company.tripName,
                          widget.info.tripNo,
                          true,
                        );
                      } else if (widget.info.status == TripStatus.started) {
                        // finishing action...
                        showOkayDialog(
                          context,
                          widget.info.company.companyName,
                          widget.info.company.tripName,
                          widget.info.tripNo,
                          false,
                        );
                      }
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
                  // navigation to ?...
                } else {
                  showRejectDialog(context, widget.info.company.companyName,
                      widget.info.company.tripName, widget.info.tripNo);
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
              child: Image.asset(widget.info.getStatusImgPath()),
            ),
            Text(
              widget.info.getStatusStr(),
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
            widget.info.getTripNoStr(),
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500,
              fontSize: 36.sp,
              color: widget.info.getStatusColor(),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 50.w),
          child: Column(
            children: [
              _buildCompanyRow(),
              SizedBox(height: 8.h),
              TripBusLine(info: widget.info.busLine),
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
    SizeConfig().init(context);

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
