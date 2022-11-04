import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:alnabali_driver/src/constants/app_styles.dart';
import 'package:alnabali_driver/src/features/profile/profile.dart';
import 'package:alnabali_driver/src/features/profile/profile_controllers.dart';
import 'package:alnabali_driver/src/routing/app_router.dart';
import 'package:alnabali_driver/src/utils/async_value_ui.dart';
import 'package:alnabali_driver/src/utils/string_hardcoded.dart';
import 'package:alnabali_driver/src/widgets/progress_hud.dart';
import 'package:alnabali_driver/src/widgets/custom_painter.dart';
import 'package:alnabali_driver/src/widgets/dialogs.dart';

class HomeAccountPage extends ConsumerStatefulWidget {
  const HomeAccountPage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeAccountPage> createState() => _HomeAccountPageState();
}

class _HomeAccountPageState extends ConsumerState<HomeAccountPage> {
  var _profile = Profile(
    username: 'unknown@email.com',
    profileImage: 'assets/images/user_avatar.png',
    nameEN: 'Unknown Driver',
    phone: '123456789',
    birthday: '1900-01-01',
    address: 'Unknown Address',
    workingHours: 0,
    totalDistance: 0,
    totalTrips: 0,
  );

  @override
  void initState() {
    super.initState();

    final controller = ref.read(homeAccountControllerProvider.notifier);
    controller.doGetProfile().then((value) {
      setState(() => _profile = value);
    });
  }

  Widget _buildSummaryInfo(int index, String value) {
    double iconHeight;
    String greyText;
    if (index == 0) {
      iconHeight = 77.h;
      greyText = 'Working Hours';
    } else if (index == 1) {
      iconHeight = 57.h;
      greyText = 'Total Distance';
    } else {
      iconHeight = 89.h;
      greyText = 'Total Trips';
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 14),
            height: iconHeight,
            child: Image.asset('assets/images/user_icon$index.png'),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600,
              fontSize: 46.sp,
              color: kColorPrimaryBlue,
            ),
          ),
          Text(
            greyText,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500,
              fontSize: 32.sp,
              color: const Color(0xFF808080),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
        homeAccountControllerProvider.select((state) => state),
        (_, state) => state.showAlertDialogOnError(context));

    final state = ref.watch(homeAccountControllerProvider);

    final btnStyle = ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
            side: const BorderSide(color: kColorPrimaryBlue)),
      ),
    );
    final btnTextStyle = TextStyle(
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.w500,
      fontSize: 40.sp,
      color: kColorPrimaryBlue,
    );
    final btnW = 600.w;

    return ProgressHUD(
      inAsyncCall: state.isLoading,
      child: Column(
        //crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 50.h),
            height: 192.h,
            child: Image.asset('assets/images/home_icon.png'),
          ),
          Expanded(
            child: Stack(
              alignment: AlignmentDirectional.topCenter,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 20.h),
                  child: SizedBox.expand(
                    child: CustomPaint(painter: AccountBgPainter()),
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 20.h),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: kColorAvatarBorder, width: 1),
                        ),
                        child: CircleAvatar(
                          radius: 165.h,
                          backgroundColor: Colors.transparent,
                          backgroundImage: AssetImage(_profile.profileImage),
                        ),
                      ),
                      Flexible(child: SizedBox(height: 20.h)),
                      Text(
                        _profile.nameEN,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500,
                          fontSize: 45.sp,
                          color: kColorPrimaryBlue,
                        ),
                      ),
                      Flexible(child: SizedBox(height: 20.h)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _buildSummaryInfo(0, '${_profile.workingHours}'),
                          _buildSummaryInfo(1, '${_profile.totalDistance} KM'),
                          _buildSummaryInfo(2, '${_profile.totalTrips}'),
                        ],
                      ),
                      Flexible(child: SizedBox(height: 100.h)),
                      TextButton(
                        onPressed: () {
                          context.goNamed(AppRoute.editProfile.name);
                        },
                        style: btnStyle,
                        child: Container(
                          alignment: Alignment.center,
                          width: btnW,
                          child: Text('Edit Profile'.hardcoded,
                              style: btnTextStyle),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          context.goNamed(AppRoute.changePwd.name);
                        },
                        style: btnStyle,
                        child: Container(
                          alignment: Alignment.center,
                          width: btnW,
                          child: Text('Reset Password'.hardcoded,
                              style: btnTextStyle),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        style: btnStyle,
                        child: Container(
                          alignment: Alignment.center,
                          width: btnW,
                          child: Text('Call App Supervisor'.hardcoded,
                              style: btnTextStyle),
                        ),
                      ),
                      Flexible(child: SizedBox(height: 40.h)),
                      TextButton(
                        onPressed: () {
                          showLogoutDialog(context).then((value) {
                            if (value != null && value == true) {
                              context.goNamed(AppRoute.login.name);
                            }
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(kColorPrimaryBlue),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                                side:
                                    const BorderSide(color: kColorPrimaryBlue)),
                          ),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          width: btnW,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 30.w),
                                height: 53.h,
                                child: Image.asset(
                                    'assets/images/user_icon_logout.png'),
                              ),
                              Text(
                                'LOG OUT'.hardcoded,
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 40.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Flexible(child: SizedBox(height: 40.h)),
                      Text(
                        'App Version 0100.0'.hardcoded,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500,
                          fontSize: 34.sp,
                          color: kColorPrimaryBlue,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
