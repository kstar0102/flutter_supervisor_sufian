import 'package:alnabali_driver/src/constants/app_styles.dart';
import 'package:alnabali_driver/src/features/profile/change_password_controller.dart';
import 'package:alnabali_driver/src/routing/app_router.dart';
import 'package:alnabali_driver/src/utils/async_value_ui.dart';
import 'package:alnabali_driver/src/utils/string_hardcoded.dart';
import 'package:alnabali_driver/src/widgets/progress_hud.dart';
import 'package:flutter/material.dart';

import 'package:alnabali_driver/src/widgets/constants.dart';
import 'package:alnabali_driver/src/widgets/custom_painter.dart';
import 'package:alnabali_driver/src/features/profile/profile_textfield.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(changePwdControllerProvider.select((state) => state),
        (_, state) => state.showAlertDialogOnError(context));
    final state = ref.watch(changePwdControllerProvider);

    final spacer = Flexible(child: SizedBox(height: 20.h));

    return Scaffold(
      body: SizedBox.expand(
        child: Container(
          decoration: kBgDecoration,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 150.h),
                child: Text(
                  'CHANGE PASSWORD'.hardcoded,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w800,
                    fontSize: 48.sp,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: Stack(
                  alignment: AlignmentDirectional.topCenter,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 260.h),
                      child: SizedBox.expand(
                        child: CustomPaint(painter: AccountBgPainter()),
                      ),
                    ),
                    ProgressHUD(
                      inAsyncCall: state.isLoading,
                      child: Column(
                        children: [
                          Container(
                            height: 192.h,
                            margin: EdgeInsets.only(top: 130.h),
                            child: Image.asset('assets/images/home_icon.png'),
                          ),
                          Flexible(child: SizedBox(height: 500.h)),
                          const ProfileTextField(
                              txtFieldType: ProfileTextFieldType.currPassword),
                          spacer,
                          const ProfileTextField(
                              txtFieldType: ProfileTextFieldType.newPassword),
                          spacer,
                          const ProfileTextField(
                              txtFieldType:
                                  ProfileTextFieldType.confirmPassword),
                          Flexible(child: SizedBox(height: 140.h)),
                          SizedBox(
                            width: 680.w,
                            child: ElevatedButton(
                              onPressed: () {
                                ref
                                    .read(changePwdControllerProvider.notifier)
                                    .tryChangePwd('aaaaaa', 'ffffff');
                                //context.goNamed(AppRoute.home.name);
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: kColorPrimaryBlue,
                                shape: const StadiumBorder(),
                              ),
                              child: Text(
                                'SAVE'.hardcoded,
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 42.sp,
                                ),
                              ),
                            ),
                          ),
                          //const Expanded(child: SizedBox(height: double.infinity)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: SizedBox(
          height: 150.h,
          child: IconButton(
            onPressed: () => context.goNamed(AppRoute.home.name),
            //iconSize: 89.h,
            icon: Image.asset('assets/images/btn_back.png'),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    );
  }
}
