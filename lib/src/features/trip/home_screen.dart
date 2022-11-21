import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:alnabali_driver/src/constants/app_styles.dart';
import 'package:alnabali_driver/src/features/notification/home_notifications_page.dart';
import 'package:alnabali_driver/src/features/profile/home_account_page.dart';
import 'package:alnabali_driver/src/features/trip/home_trips_page.dart';
import 'package:alnabali_driver/src/widgets/app_icons_icons.dart';
import 'package:alnabali_driver/src/widgets/gnav/gnav.dart';
import 'package:alnabali_driver/src/widgets/gnav/gbutton.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _controller = PageController();
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    double gap = 10;
    final padding = EdgeInsets.symmetric(horizontal: 60.w, vertical: 30.h);

    return Scaffold(
      extendBody: true,
      body: Container(
        width: ScreenUtil().screenWidth,
        height: ScreenUtil().screenHeight,
        decoration: kBgDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 12.h),
              height: 192.h,
              child: Image.asset('assets/images/home_icon.png'),
            ),
            Expanded(
              child: PageView.builder(
                onPageChanged: (page) {
                  setState(() {
                    selectedIndex = page;
                    //badge = badge + 1;
                  });
                },
                controller: _controller,
                itemCount: 3,
                itemBuilder: (context, position) {
                  if (position == 0) {
                    return const HomeTripsPage();
                  } else if (position == 1) {
                    return const HomeNotificationsPage();
                  } else {
                    return const HomeAccountPage();
                  }
                },
              ),
            ),
          ],
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
                  text: AppLocalizations.of(context).trips,
                ),
                GButton(
                  gap: gap,
                  iconActiveColor: kColorPrimaryBlue,
                  iconColor: Colors.white,
                  backgroundColor: Colors.white,
                  iconSize: 80.sp,
                  padding: padding,
                  icon: AppIcons.nav2,
                  text: AppLocalizations.of(context).notification,
                ),
                GButton(
                  gap: gap,
                  iconActiveColor: kColorPrimaryBlue,
                  iconColor: Colors.white,
                  backgroundColor: Colors.white,
                  iconSize: 80.sp,
                  padding: padding,
                  icon: AppIcons.nav3,
                  text: AppLocalizations.of(context).account,
                )
              ],
              selectedIndex: selectedIndex,
              onTabChange: (index) {
                setState(() {
                  selectedIndex = index;
                });
                _controller.jumpToPage(index);
              },
            ),
          ),
        ),
      ),
    );
  }
}
