import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:alnabali_driver/src/constants/app_styles.dart';
import 'package:alnabali_driver/src/features/profile/profile_controllers.dart';
import 'package:alnabali_driver/src/features/profile/profile_textfield.dart';
import 'package:alnabali_driver/src/utils/async_value_ui.dart';
import 'package:alnabali_driver/src/utils/string_hardcoded.dart';
import 'package:alnabali_driver/src/widgets/custom_painter.dart';
import 'package:alnabali_driver/src/widgets/dialogs.dart';
import 'package:alnabali_driver/src/widgets/progress_hud.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _birthday = TextEditingController();
  final _address = TextEditingController();
  String _avatarImg = 'assets/images/user_avatar.png';
  String _nameEn = 'unknown'.hardcoded;

  @override
  void initState() {
    super.initState();

    // edit controllers must be initialized only once!
    var profile = ref.read(profileControllerProvider.notifier).currProfile;
    if (profile != null) {
      _name.text = profile.nameEN;
      _phone.text = profile.phone;
      _birthday.text = profile.birthday;
      _address.text = profile.address;
      _avatarImg = profile.profileImage;
      _nameEn = profile.nameEN;
    }
  }

  void _submit() {
    final controller = ref.read(profileControllerProvider.notifier);
    controller
        .doEditProfile(_name.text, _phone.text, _birthday.text, _address.text)
        .then((value) {
      if (value == true) {
        showToastMessage('Updated profile successfully.'.hardcoded);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(profileControllerProvider.select((state) => state),
        (_, state) => state.showAlertDialogOnError(context));

    final state = ref.watch(profileControllerProvider);
    final profile = state.value;

    final spacer = Flexible(child: SizedBox(height: 20.h));

    return Scaffold(
      body: Container(
        decoration: kBgDecoration,
        child: ProgressHUD(
          inAsyncCall: state.isLoading,
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(vertical: 150.h),
                child: Text(
                  'EDIT PROFILE'.hardcoded,
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
                      margin: EdgeInsets.only(top: 40.h),
                      child: SizedBox.expand(
                        child: CustomPaint(painter: AccountBgPainter()),
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 40.h),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: kColorAvatarBorder, width: 1.0),
                          ),
                          child: CircleAvatar(
                            radius: 165.h,
                            backgroundColor: Colors.transparent,
                            backgroundImage: AssetImage(profile != null
                                ? profile.profileImage
                                : _avatarImg),
                          ),
                        ),
                        Flexible(child: SizedBox(height: 30.h)),
                        Text(
                          profile != null ? profile.nameEN : _nameEn,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w500,
                            fontSize: 42.sp,
                            color: kColorPrimaryBlue,
                          ),
                        ),
                        Flexible(child: SizedBox(height: 100.h)),
                        ProfileTextField(
                          txtFieldType: ProfileTextFieldType.name,
                          controller: _name,
                        ),
                        spacer,
                        ProfileTextField(
                          txtFieldType: ProfileTextFieldType.phone,
                          controller: _phone,
                        ),
                        spacer,
                        ProfileTextField(
                          txtFieldType: ProfileTextFieldType.dateOfBirth,
                          controller: _birthday,
                        ),
                        spacer,
                        ProfileTextField(
                          txtFieldType: ProfileTextFieldType.address,
                          controller: _address,
                        ),
                        Flexible(child: SizedBox(height: 140.h)),
                        SizedBox(
                          width: 685.w,
                          child: ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
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
                      ],
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
            onPressed: () {
              context.pop();
            },
            icon: Image.asset('assets/images/btn_back.png'),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    );
  }
}
