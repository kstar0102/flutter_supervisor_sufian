import 'dart:developer' as developer;
import 'package:alnabali_driver/src/features/profile/profile_repository.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:alnabali_driver/src/constants/app_styles.dart';
import 'package:alnabali_driver/src/features/profile/profile_controllers.dart';
import 'package:alnabali_driver/src/routing/app_router.dart';
import 'package:alnabali_driver/src/utils/async_value_ui.dart';
import 'package:alnabali_driver/src/utils/string_hardcoded.dart';
import 'package:alnabali_driver/src/widgets/custom_painter.dart';
import 'package:alnabali_driver/src/widgets/dialogs.dart';
import 'package:alnabali_driver/src/widgets/progress_hud.dart';

class HomeAccountPage extends ConsumerStatefulWidget {
  const HomeAccountPage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeAccountPage> createState() => _HomeAccountPageState();
}

class _HomeAccountPageState extends ConsumerState<HomeAccountPage> {
  @override
  void initState() {
    super.initState();

    ref.read(homeAccountCtrProvider.notifier).doGetProfile();
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
    ref.listen<AsyncValue>(homeAccountCtrProvider.select((state) => state),
        (_, state) => state.showAlertDialogOnError(context));

    final state = ref.watch(homeAccountCtrProvider);
    final profile = ref.watch(profileStateChangesProvider).value;

    developer.log('HomeAccountPage::build() - profile=${profile?.nameEN}');

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
      fontSize: 44.sp,
      color: kColorPrimaryBlue,
    );
    final btnW = 620.w;
    final btnH = 80.h;

    return ProgressHUD(
      inAsyncCall: state.isLoading,
      opacity: 0,
      child: Column(
        //crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(
              alignment: AlignmentDirectional.topCenter,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 140.h),
                  child: SizedBox.expand(
                    child: CustomPaint(painter: AccountBgPainter()),
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 140.h),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: kColorAvatarBorder, width: 1),
                        ),
                        child: CircleAvatar(
                          radius: 165.h,
                          backgroundColor: Colors.transparent,
                          backgroundImage: profile == null
                              ? null
                              : AssetImage(profile.profileImage),
                        ),
                      ),
                      Flexible(child: SizedBox(height: 20.h)),
                      Text(
                        profile?.nameEN ?? 'unknown'.hardcoded,
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
                          _buildSummaryInfo(0, '${profile?.workingHours ?? 0}'),
                          _buildSummaryInfo(
                              1, '${profile?.totalDistance ?? 0} KM'),
                          _buildSummaryInfo(2, '${profile?.totalTrips ?? 0}'),
                        ],
                      ),
                      Flexible(child: SizedBox(height: 160.h)),
                      TextButton(
                        onPressed: state.isLoading
                            ? null
                            : () =>
                                context.pushNamed(AppRoute.editProfile.name),
                        style: btnStyle,
                        child: Container(
                          alignment: Alignment.center,
                          width: btnW,
                          height: btnH,
                          child: Text('Edit Profile'.hardcoded,
                              style: btnTextStyle),
                        ),
                      ),
                      Flexible(child: SizedBox(height: 20.h)),
                      TextButton(
                        onPressed: state.isLoading
                            ? null
                            : () => context.pushNamed(AppRoute.changePwd.name),
                        style: btnStyle,
                        child: Container(
                          alignment: Alignment.center,
                          width: btnW,
                          height: btnH,
                          child: Text('Change Password'.hardcoded,
                              style: btnTextStyle),
                        ),
                      ),
                      Flexible(child: SizedBox(height: 20.h)),
                      TextButton(
                        onPressed: state.isLoading ? null : () {},
                        style: btnStyle,
                        child: Container(
                          alignment: Alignment.center,
                          width: btnW,
                          height: btnH,
                          child: Text('Call App Supervisor'.hardcoded,
                              style: btnTextStyle),
                        ),
                      ),
                      Flexible(child: SizedBox(height: 100.h)),
                      TextButton(
                        onPressed: state.isLoading
                            ? null
                            : () {
                                showLogoutDialog(context).then((value) {
                                  if (value != null && value == true) {
                                    ref
                                        .read(homeAccountCtrProvider.notifier)
                                        .doLogout();

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
                          height: btnH,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 40.w),
                                height: 53.h,
                                child: Image.asset(
                                    'assets/images/user_icon_logout.png'),
                              ),
                              Text(
                                'LOG OUT'.hardcoded,
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 44.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Flexible(child: SizedBox(height: 60.h)),
                      Text(
                        'App Version 0100.0'.hardcoded,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500,
                          fontSize: 36.sp,
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
