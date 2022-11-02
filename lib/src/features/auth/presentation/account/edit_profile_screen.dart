import 'package:alnabali_driver/src/features/auth/presentation/account/edit_profile_controller.dart';
import 'package:alnabali_driver/src/utils/async_value_ui.dart';
import 'package:alnabali_driver/src/widgets/progress_hud.dart';
import 'package:flutter/material.dart';

import 'package:alnabali_driver/src/widgets/constants.dart';
import 'package:alnabali_driver/src/widgets/custom_painter.dart';
import 'package:alnabali_driver/src/widgets/profile_textfield.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    ref.listen<AsyncValue>(
        editProfileControllerProvider.select((state) => state),
        (_, state) => state.showAlertDialogOnError(context));
    final state = ref.watch(editProfileControllerProvider);

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
                  'EDIT PROFILE',
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
                          margin: EdgeInsets.only(top: 170 * SizeConfig.scaleY),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: kColorAvatarBorder, width: 1.0),
                          ),
                          child: CircleAvatar(
                            radius: 165 * SizeConfig.scaleY,
                            backgroundColor: Colors.transparent,
                            backgroundImage: const AssetImage(
                                'assets/images/user_avatar.png'),
                          ),
                        ),
                        Flexible(
                            child: SizedBox(height: 30 * SizeConfig.scaleY)),
                        const Text(
                          'Sufian Abu Alabban',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w500,
                            fontSize: 19,
                            color: kColorPrimaryBlue,
                          ),
                        ),
                        Flexible(
                            child: SizedBox(height: 200 * SizeConfig.scaleY)),
                        const ProfileTextField(
                            txtFieldType: ProfileTextFieldType.name),
                        spacer,
                        const ProfileTextField(
                            txtFieldType: ProfileTextFieldType.phone),
                        spacer,
                        const ProfileTextField(
                            txtFieldType: ProfileTextFieldType.dateOfBirth),
                        spacer,
                        const ProfileTextField(
                            txtFieldType: ProfileTextFieldType.address),
                        Flexible(
                            child: SizedBox(height: 150 * SizeConfig.scaleY)),
                        SizedBox(
                          width: 685 * SizeConfig.scaleX,
                          height: 120 * SizeConfig.scaleY,
                          child: ElevatedButton(
                            onPressed: () {
                              ref
                                  .read(editProfileControllerProvider.notifier)
                                  .tryEditProfile(
                                    'Alabban',
                                    '987654321',
                                    '1992-6-6',
                                    'amman city',
                                  );
                              //context.goNamed(AppRoute.home.name);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kColorPrimaryBlue,
                              shape: const StadiumBorder(),
                            ),
                            child: const Text(
                              'SAVE',
                              style: TextStyle(
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
