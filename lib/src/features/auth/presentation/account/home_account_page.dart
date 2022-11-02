import 'package:alnabali_driver/src/features/auth/data/auth_repository.dart';
import 'package:alnabali_driver/src/features/auth/presentation/account/home_account_controller.dart';
import 'package:alnabali_driver/src/routing/app_router.dart';
import 'package:alnabali_driver/src/utils/async_value_ui.dart';
import 'package:alnabali_driver/src/utils/string_hardcoded.dart';
import 'package:alnabali_driver/src/widgets/progress_hud.dart';
import 'package:flutter/material.dart';

import 'package:alnabali_driver/src/widgets/constants.dart';
import 'package:alnabali_driver/src/widgets/custom_painter.dart';
import 'package:alnabali_driver/src/widgets/dialogs.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeAccountPage extends ConsumerStatefulWidget {
  const HomeAccountPage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeAccountPage> createState() => _HomeAccountPageState();
}

class _HomeAccountPageState extends ConsumerState<HomeAccountPage> {
  @override
  void initState() {
    super.initState();

    //* if profile not loaded ever, do it now.
    ref.read(accountControllerProvider.notifier).tryGetProfile();
  }

  Widget _buildSummaryInfo(int index, String value) {
    double iconHeight;
    String greyText;
    if (index == 0) {
      iconHeight = 34;
      greyText = 'Working Hours';
    } else if (index == 1) {
      iconHeight = 28;
      greyText = 'Total Distance';
    } else {
      iconHeight = 38;
      greyText = 'Total Trips';
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 14),
            height: iconHeight,
            child: Image.asset('assets/images/user_icon$index.png'),
          ),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: kColorPrimaryBlue,
            ),
          ),
          Text(
            greyText,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Color(0xFF808080),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    ref.listen<AsyncValue>(accountControllerProvider.select((state) => state),
        (_, state) => state.showAlertDialogOnError(context));

    final btnStyle = ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
            side: const BorderSide(color: kColorPrimaryBlue)),
      ),
    );
    const btnTextStyle = TextStyle(
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.w600,
      fontSize: 18,
      color: kColorPrimaryBlue,
    );

    final state = ref.watch(accountControllerProvider);
    final user = ref.watch(userStateChangesProvider).value;

    String profileImg = 'assets/images/user_avatar.png';
    String nameEn = 'Driver\'s Name';
    double hours = 0, dist = 0, trips = 0;
    var profile = user?.profile;
    if (profile != null) {
      profileImg = profile.profileImage.isEmpty
          ? 'assets/images/user_avatar.png'
          : profile.profileImage;
      nameEn = profile.nameEN;
      hours = 10.2;
      dist = 30;
      trips = 20;
    }

    return ProgressHUD(
      inAsyncCall: state.isLoading,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            height: 192 * SizeConfig.scaleY,
            child: Image.asset('assets/images/home_icon.png'),
          ),
          Expanded(
            child: Stack(
              alignment: AlignmentDirectional.topCenter,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 170 * SizeConfig.scaleY),
                  child: SizedBox.expand(
                    child: CustomPaint(painter: AccountBgPainter()),
                  ),
                ),
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 170 * SizeConfig.scaleY),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: kColorAvatarBorder, width: 1.0),
                      ),
                      child: CircleAvatar(
                        radius: 165 * SizeConfig.scaleY,
                        backgroundColor: Colors.transparent,
                        backgroundImage: AssetImage(profileImg),
                      ),
                    ),
                    Flexible(child: SizedBox(height: 30 * SizeConfig.scaleY)),
                    Text(
                      nameEn,
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500,
                        fontSize: 19,
                        color: kColorPrimaryBlue,
                      ),
                    ),
                    Flexible(child: SizedBox(height: 70 * SizeConfig.scaleY)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildSummaryInfo(0, hours.toString()),
                        _buildSummaryInfo(1, '$dist KM'),
                        _buildSummaryInfo(2, trips.toString()),
                      ],
                    ),
                    Flexible(
                        flex: 2,
                        child: SizedBox(height: 190 * SizeConfig.scaleY)),
                    TextButton(
                      onPressed: () {
                        context.goNamed(AppRoute.editProfile.name);
                      },
                      style: btnStyle,
                      child: Container(
                        alignment: Alignment.center,
                        width: 300,
                        height: 52,
                        child:
                            Text('Edit Profile'.hardcoded, style: btnTextStyle),
                      ),
                    ),
                    Flexible(child: SizedBox(height: 30 * SizeConfig.scaleY)),
                    TextButton(
                      onPressed: () {
                        context.goNamed(AppRoute.changePwd.name);
                      },
                      style: btnStyle,
                      child: Container(
                        alignment: Alignment.center,
                        width: 300,
                        height: 52,
                        child: Text('Reset Password'.hardcoded,
                            style: btnTextStyle),
                      ),
                    ),
                    Flexible(child: SizedBox(height: 30 * SizeConfig.scaleY)),
                    TextButton(
                      onPressed: () {},
                      style: btnStyle,
                      child: Container(
                        alignment: Alignment.center,
                        width: 300,
                        height: 52,
                        child: Text('Call App Supervisor'.hardcoded,
                            style: btnTextStyle),
                      ),
                    ),
                    Flexible(child: SizedBox(height: 110 * SizeConfig.scaleY)),
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
                              side: const BorderSide(color: kColorPrimaryBlue)),
                        ),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        width: 300,
                        height: 52,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 18),
                              height: 24,
                              child: Image.asset(
                                  'assets/images/user_icon_logout.png'),
                            ),
                            const Text(
                              'LOG OUT',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Flexible(child: SizedBox(height: 80 * SizeConfig.scaleY)),
                    const Text(
                      'App Version 0100.0',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: kColorPrimaryBlue,
                      ),
                    ),
                    Flexible(
                        flex: 3,
                        child: SizedBox(height: 170 * SizeConfig.scaleY)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
