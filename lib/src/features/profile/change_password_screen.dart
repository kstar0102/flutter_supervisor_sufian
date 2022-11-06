import 'package:alnabali_driver/src/widgets/dialogs.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:alnabali_driver/src/constants/app_styles.dart';
import 'package:alnabali_driver/src/features/profile/profile_textfield.dart';
import 'package:alnabali_driver/src/features/profile/profile_controllers.dart';
import 'package:alnabali_driver/src/widgets/progress_hud.dart';
import 'package:alnabali_driver/src/utils/async_value_ui.dart';
import 'package:alnabali_driver/src/utils/string_hardcoded.dart';
import 'package:alnabali_driver/src/widgets/custom_painter.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _curr = TextEditingController();
  final _new1 = TextEditingController();
  final _new2 = TextEditingController();

  void _submit() {
    final controller = ref.read(changePasswordControllerProvider.notifier);
    controller.doChangePassword(_curr.text, _new1.text).then((value) {
      if (value == true) {
        _curr.clear();
        _new1.clear();
        _new2.clear();

        showToastMessage('Changed password successfully.'.hardcoded);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
        changePasswordControllerProvider.select((state) => state),
        (_, state) => state.showAlertDialogOnError(context));

    final state = ref.watch(changePasswordControllerProvider);

    final spacer = Flexible(child: SizedBox(height: 20.h));

    return Scaffold(
      body: SizedBox.expand(
        child: ProgressHUD(
          inAsyncCall: state.isLoading,
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
                      Column(
                        children: [
                          Container(
                            height: 192.h,
                            margin: EdgeInsets.only(top: 130.h),
                            child: Image.asset('assets/images/home_icon.png'),
                          ),
                          Flexible(child: SizedBox(height: 500.h)),
                          ProfileTextField(
                            txtFieldType: ProfileTextFieldType.currPassword,
                            controller: _curr,
                          ),
                          spacer,
                          ProfileTextField(
                            txtFieldType: ProfileTextFieldType.newPassword,
                            controller: _new1,
                          ),
                          spacer,
                          ProfileTextField(
                            txtFieldType: ProfileTextFieldType.confirmPassword,
                            controller: _new2,
                          ),
                          Flexible(child: SizedBox(height: 140.h)),
                          SizedBox(
                            width: 680.w,
                            child: ElevatedButton(
                              onPressed: _submit,
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: SizedBox(
          height: 150.h,
          child: IconButton(
            onPressed: () => context.pop(),
            icon: Image.asset('assets/images/btn_back.png'),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    );
  }
}
