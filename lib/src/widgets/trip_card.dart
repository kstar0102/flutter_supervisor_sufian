import 'package:alnabali_driver/src/features/trip/data/trip_info.dart';
import 'package:flutter/material.dart';

import 'package:alnabali_driver/src/widgets/constants.dart';
import 'package:alnabali_driver/src/widgets/trip_busline.dart';
import 'package:alnabali_driver/src/widgets/gradient_button.dart';
import 'package:alnabali_driver/src/widgets/dialogs.dart';

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
    final avatarRadius = 106 * SizeConfig.scaleX * 0.5;

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
            padding: const EdgeInsets.only(left: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.info.company.companyName,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: kColorPrimaryGrey,
                  ),
                ),
                Text(
                  widget.info.company.tripName,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    fontSize: 11,
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
            const Text(
              'BUS NO.',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w500,
                fontSize: 10,
                color: kColorPrimaryBlue,
              ),
            ),
            Text(
              widget.info.busNo,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: kColorPrimaryBlue,
              ),
            ),
            const Text(
              'Passengers',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w500,
                fontSize: 10,
                color: kColorPrimaryBlue,
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width: 38 * SizeConfig.scaleX,
                  child: Image.asset('assets/images/passengers.png'),
                ),
                const SizedBox(width: 4),
                Text(
                  widget.info.passengers.toString(),
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
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
          margin: const EdgeInsets.only(top: 20, bottom: 4),
          child: const Text(
            'REASON FOR REJECTION',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: kColorPrimaryBlue,
            ),
          ),
        ),
        Text(
          widget.info.rejectReason,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: kColorSecondaryGrey,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20, bottom: 4),
          child: const Text(
            'DETAILS',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: kColorPrimaryBlue,
            ),
          ),
        ),
        Text(
          widget.info.busLine.courseDetail,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: kColorSecondaryGrey,
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
      final btnW = 268 * SizeConfig.scaleX;
      final btnH = btnW * 0.26;
      String yesTitle = 'ACCEPT';
      String noTitle = 'REJECT';
      if (widget.info.status == TripStatus.started) {
        yesTitle = 'FINISH';
        noTitle = 'NAVIGATION';
      } else if (widget.info.status == TripStatus.accepted) {
        yesTitle = 'START';
      }

      return SizedBox(
        height: btnH + 34,
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
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 2),
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
      return const SizedBox(height: 36);
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
              width: 410 * SizeConfig.scaleX,
              child: Image.asset(widget.info.getStatusImgPath()),
            ),
            Text(
              widget.info.getStatusStr(),
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w400,
                fontSize: 17,
                color: Colors.white,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text(
            widget.info.getTripNoStr(),
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500,
              fontSize: 15,
              color: widget.info.getStatusColor(),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              _buildCompanyRow(),
              const SizedBox(height: 2),
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

        Navigator.pushNamed(context, '/trip_detail');
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 30),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.withOpacity(0.5)),
          borderRadius: const BorderRadius.all(Radius.circular(18)),
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
