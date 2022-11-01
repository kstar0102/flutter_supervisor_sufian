import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:alnabali_driver/src/widgets/constants.dart';

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
    SizeConfig().init(context);

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

    final fieldW = 685 * SizeConfig.scaleX;
    final fieldH = 120 * SizeConfig.scaleY;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Text(
            guideText,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500,
              fontSize: 14,
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
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  prefixText,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  alignment: Alignment.centerLeft,
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
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
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
