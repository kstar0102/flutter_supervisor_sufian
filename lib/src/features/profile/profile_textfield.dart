import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:alnabali_driver/src/widgets/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// text field types used in profile screen.
enum ProfileTextFieldType {
  name,
  phone,
  dateOfBirth,
  address,
  currPassword,
  newPassword,
  confirmPassword,
}

class ProfileTextField extends StatefulWidget {
  final ProfileTextFieldType txtFieldType;

  const ProfileTextField({
    Key? key,
    required this.txtFieldType,
  }) : super(key: key);

  @override
  State<ProfileTextField> createState() => _ProfileTextFieldState();
}

class _ProfileTextFieldState extends State<ProfileTextField> {
  @override
  Widget build(BuildContext context) {
    String guideText = '';
    String prefixText = '';
    bool isObscureText = false;
    TextInputType inputType = TextInputType.text;
    List<TextInputFormatter> formatters = <TextInputFormatter>[
      FilteringTextInputFormatter.deny('\n')
    ];
    if (widget.txtFieldType == ProfileTextFieldType.name) {
      guideText = 'Name';
      inputType = TextInputType.name;
    } else if (widget.txtFieldType == ProfileTextFieldType.phone) {
      guideText = 'Phone';
      prefixText = '+962';
      inputType = TextInputType.phone;
      formatters.add(FilteringTextInputFormatter.digitsOnly);
    } else if (widget.txtFieldType == ProfileTextFieldType.dateOfBirth) {
      guideText = 'Date of Birth';
      inputType = TextInputType.datetime;
      formatters.add(FilteringTextInputFormatter.digitsOnly);
    } else if (widget.txtFieldType == ProfileTextFieldType.address) {
      guideText = 'Address';
      inputType = TextInputType.streetAddress;
    } else if (widget.txtFieldType == ProfileTextFieldType.currPassword) {
      guideText = 'Current Password';
      isObscureText = true;
      inputType = TextInputType.visiblePassword;
    } else if (widget.txtFieldType == ProfileTextFieldType.newPassword) {
      guideText = 'New Password';
      isObscureText = true;
      inputType = TextInputType.visiblePassword;
    } else if (widget.txtFieldType == ProfileTextFieldType.confirmPassword) {
      guideText = 'Confirm New Password';
      isObscureText = true;
      inputType = TextInputType.visiblePassword;
    }

    final fieldW = 700.w;
    final fieldH = 130.h;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 46.w, vertical: 10.h),
          child: Text(
            guideText,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500,
              fontSize: 32.sp,
              color: kColorPrimaryBlue,
            ),
          ),
        ),
        Container(
          width: fieldW,
          height: fieldH,
          decoration: BoxDecoration(
            color: kColorPrimaryBlue,
            border: Border.all(color: kColorPrimaryBlue),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: Text(
                  prefixText,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    fontSize: 36.sp,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.horizontal(right: Radius.circular(100)),
                  ),
                  child: TextField(
                    obscureText: isObscureText,
                    keyboardType: inputType,
                    inputFormatters: formatters,
                    cursorColor: kColorSecondaryGrey,
                    decoration: const InputDecoration(border: InputBorder.none),
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      fontSize: 48.sp,
                      color: kColorSecondaryGrey,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
