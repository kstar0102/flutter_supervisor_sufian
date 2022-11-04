import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:alnabali_driver/src/constants/app_styles.dart';
import 'package:alnabali_driver/src/features/trip/home_trips_list.dart';
import 'package:alnabali_driver/src/utils/string_hardcoded.dart';

class HomeTripsPage extends StatefulWidget {
  const HomeTripsPage({Key? key}) : super(key: key);

  @override
  State<HomeTripsPage> createState() => _HomeTripsPageState();
}

class _HomeTripsPageState extends State<HomeTripsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryTabBarHMargin = 150.w;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 10.h),
          height: 192.h,
          child: Image.asset('assets/images/home_icon.png'),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(90.w),
              ),
            ),
            child: Column(
              children: [
                Container(
                  height: 124.h,
                  margin: EdgeInsets.only(
                    left: primaryTabBarHMargin,
                    right: primaryTabBarHMargin,
                    top: 54.h,
                    bottom: 34.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFB3B3B3),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      color: kColorPrimaryBlue,
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white,
                    labelStyle: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      fontSize: 40.sp,
                    ),
                    tabs: [
                      Tab(text: 'TODAY TRIPS'.hardcoded),
                      Tab(text: 'PAST TRIPS'.hardcoded),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: const [
                      TripsListView(listType: TripsListType.todayTrips),
                      TripsListView(listType: TripsListType.pastTrips),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
