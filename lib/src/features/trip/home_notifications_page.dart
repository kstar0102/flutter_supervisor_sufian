import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:alnabali_driver/src/features/trip/notification_card.dart';

class HomeNotificationsPage extends StatefulWidget {
  const HomeNotificationsPage({Key? key}) : super(key: key);

  @override
  State<HomeNotificationsPage> createState() => _HomeNotificationsPageState();
}

class _HomeNotificationsPageState extends State<HomeNotificationsPage> {
  @override
  Widget build(BuildContext context) {
    /// dummy codes for test
    final dummyInfos = [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          height: 80,
          child: Image.asset('assets/images/home_icon.png'),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(36.h),
              ),
            ),
            child: ListView.separated(
              padding: const EdgeInsets.only(top: 30),
              itemCount: dummyInfos.length,
              itemBuilder: (BuildContext context, int itemIdx) {
                return NotificationCard(
                  info: dummyInfos[itemIdx],
                  onPressed: () {},
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(),
            ),
          ),
        ),
      ],
    );
  }
}
