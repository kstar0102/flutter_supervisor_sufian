import 'package:alnabali_driver/src/features/auth/presentation/account/change_password_controller.dart';
import 'package:alnabali_driver/src/utils/async_value_ui.dart';
import 'package:alnabali_driver/src/utils/string_hardcoded.dart';
import 'package:alnabali_driver/src/widgets/progress_hud.dart';
import 'package:flutter/material.dart';

import 'package:alnabali_driver/src/widgets/constants.dart';
import 'package:alnabali_driver/src/widgets/custom_painter.dart';
import 'package:alnabali_driver/src/widgets/profile_textfield.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    ref.listen<AsyncValue>(changePwdControllerProvider.select((state) => state),
        (_, state) => state.showAlertDialogOnError(context));
    final state = ref.watch(changePwdControllerProvider);

    final spacer = Flexible(child: SizedBox(height: 28 * SizeConfig.scaleY));

    return ProgressHUD(
      inAsyncCall: state.isLoading,
      child: Scaffold(
        body: Container(
          width: SizeConfig.screenW,
          height: SizeConfig.screenH,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg_normal.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(vertical: 90 * SizeConfig.scaleY),
                child: const Text(
                  'CHANGE PASSWORD',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w800,
                    fontSize: 19,
                    color: Colors.white,
                  ),
                ),
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
                          height: 192 * SizeConfig.scaleY,
                          margin: EdgeInsets.only(top: 50 * SizeConfig.scaleY),
                          child: Image.asset('assets/images/home_icon.png'),
                        ),
                        Flexible(
                            child: SizedBox(height: 660 * SizeConfig.scaleY)),
                        const ProfileTextField(
                            txtFieldType: ProfileTextFieldType.currPassword),
                        spacer,
                        const ProfileTextField(
                            txtFieldType: ProfileTextFieldType.newPassword),
                        spacer,
                        const ProfileTextField(
                            txtFieldType: ProfileTextFieldType.confirmPassword),
                        Flexible(
                            child: SizedBox(height: 260 * SizeConfig.scaleY)),
                        SizedBox(
                          width: 685 * SizeConfig.scaleX,
                          height: 120 * SizeConfig.scaleY,
                          child: ElevatedButton(
                            onPressed: () {
                              ref
                                  .read(changePwdControllerProvider.notifier)
                                  .tryChangePwd('aaaaaa', 'ffffff');
                              //context.goNamed(AppRoute.home.name);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kColorPrimaryBlue,
                              shape: const StadiumBorder(),
                            ),
                            child: Text(
                              'SAVE'.hardcoded,
                              style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
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
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            iconSize: 89 * SizeConfig.scaleY,
            icon: Image.asset('assets/images/btn_back.png'),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      ),
    );
  }
}
