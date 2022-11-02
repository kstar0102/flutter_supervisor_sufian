import 'package:alnabali_driver/src/features/trip/data/trip_info.dart';
import 'package:flutter/material.dart';

import 'package:alnabali_driver/src/widgets/constants.dart';

class NotificationCard extends StatefulWidget {
  final TripInfo info;
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
    SizeConfig().init(context);

    final borderRadius = BorderRadius.circular(8);
    const textColor = Color(0xFF333333);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 34, vertical: 6),
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
                  Navigator.pushNamed(context, '/trip_detail');
                },
                //splashColor: kColorPrimaryBlue.withOpacity(0.1),
                //splashFactory: InkSplash.splashFactory,
                child: Container(
                  height: 80,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  child: Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: widget.info.getStatusColor(),
                            child: const Center(
                              child: Text(
                                "TRIP",
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 10,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            widget.info.getTripNoStrShort(),
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500,
                              fontSize: 11,
                              color: widget.info.getStatusColor(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 26),
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.info.company.tripName,
                              style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                                color: textColor,
                              ),
                            ),
                            Text(
                              widget.info.getNotificationStr(),
                              style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              widget.info.busLine.getFromTimeStr(),
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                fontSize: 11,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
