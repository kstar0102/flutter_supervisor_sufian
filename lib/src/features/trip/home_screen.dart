import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:alnabali_driver/src/constants/app_styles.dart';
import 'package:alnabali_driver/src/features/notification/home_notifications_page.dart';
import 'package:alnabali_driver/src/features/profile/home_account_page.dart';
import 'package:alnabali_driver/src/features/trip/home_trips_page.dart';
import 'package:alnabali_driver/src/widgets/app_icons_icons.dart';
import 'package:alnabali_driver/src/widgets/gnav/gnav.dart';
import 'package:alnabali_driver/src/widgets/gnav/gbutton.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  //int badge = 0;
  PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    double gap = 10;
    final padding = EdgeInsets.symmetric(horizontal: 60.w, vertical: 30.h);

    return Scaffold(
      extendBody: true,
      body: SizedBox.expand(
        child: Container(
          decoration: kBgDecoration,
          child: PageView.builder(
            onPageChanged: (page) {
              setState(() {
                selectedIndex = page;
                //badge = badge + 1;
              });
            },
            controller: controller,
            itemBuilder: (context, position) {
              if (position == 0) {
                return const HomeTripsPage();
              } else if (position == 1) {
                return const HomeNotificationsPage();
              } else {
                return const HomeAccountPage();
              }
            },
            itemCount: 3,
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: EdgeInsets.all(24.h),
          decoration: BoxDecoration(
            color: kColorPrimaryBlue,
            borderRadius: const BorderRadius.all(Radius.circular(100)),
            boxShadow: [
              BoxShadow(
                spreadRadius: -10,
                blurRadius: 60,
                color: Colors.black.withOpacity(.4),
                offset: const Offset(0, 25),
              )
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(24.h),
            child: GNav(
              tabs: [
                GButton(
                  gap: gap,
                  iconActiveColor: kColorPrimaryBlue,
                  iconColor: Colors.white,
                  backgroundColor: Colors.white,
                  iconSize: 80.sp,
                  padding: padding,
                  icon: AppIcons.nav1,
                  text: 'TRIPS',
                ),
                GButton(
                  gap: gap,
                  iconActiveColor: kColorPrimaryBlue,
                  iconColor: Colors.white,
                  backgroundColor: Colors.white,
                  iconSize: 80.sp,
                  padding: padding,
                  icon: AppIcons.nav2,
                  text: 'NOTIFICATION',
                ),
                GButton(
                  gap: gap,
                  iconActiveColor: kColorPrimaryBlue,
                  iconColor: Colors.white,
                  backgroundColor: Colors.white,
                  iconSize: 80.sp,
                  padding: padding,
                  icon: AppIcons.nav3,
                  text: 'ACCOUNT',
                )
              ],
              selectedIndex: selectedIndex,
              onTabChange: (index) {
                setState(() {
                  selectedIndex = index;
                });
                controller.jumpToPage(index);
              },
            ),
          ),
        ),
      ),
    );
  }
}
