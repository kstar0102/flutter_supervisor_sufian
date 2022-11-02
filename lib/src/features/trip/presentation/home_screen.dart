import 'package:alnabali_driver/src/features/auth/presentation/account/home_account_page.dart';
import 'package:alnabali_driver/src/features/trip/presentation/home_notifications_page.dart';
import 'package:alnabali_driver/src/features/trip/presentation/home_trips_page.dart';
import 'package:flutter/material.dart';

import 'package:alnabali_driver/src/widgets/constants.dart';
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
  double gap = 10;
  final padding = const EdgeInsets.symmetric(horizontal: 18, vertical: 12);
  //int badge = 0;
  PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      extendBody: true,
      body: Container(
        width: SizeConfig.screenW,
        height: SizeConfig.screenH,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg_normal.jpg'),
            fit: BoxFit.cover,
          ),
        ),
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
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: GNav(
              tabs: [
                GButton(
                  gap: gap,
                  iconActiveColor: kColorPrimaryBlue,
                  iconColor: Colors.white,
                  backgroundColor: Colors.white,
                  iconSize: 32,
                  padding: padding,
                  icon: AppIcons.nav1,
                  text: 'TRIPS',
                ),
                GButton(
                  gap: gap,
                  iconActiveColor: kColorPrimaryBlue,
                  iconColor: Colors.white,
                  backgroundColor: Colors.white,
                  iconSize: 32,
                  padding: padding,
                  icon: AppIcons.nav2,
                  text: 'NOTIFICATION',
                ),
                GButton(
                  gap: gap,
                  iconActiveColor: kColorPrimaryBlue,
                  iconColor: Colors.white,
                  backgroundColor: Colors.white,
                  iconSize: 32,
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
