import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// text field types used in login course.
enum LoginTextFieldType {
  username,
  password,
  mobileNumber,
  newPassword,
  confirmNewPwd
}

class LoginTextField extends StatefulWidget {
  final LoginTextFieldType txtFieldType;

  const LoginTextField({
    Key? key,
    required this.txtFieldType,
  }) : super(key: key);

  @override
  State<LoginTextField> createState() => _LoginTextFieldState();
}

class _LoginTextFieldState extends State<LoginTextField> {
  @override
  Widget build(BuildContext context) {
    TextInputType inputType = TextInputType.text;
    List<TextInputFormatter> formatters = <TextInputFormatter>[
      FilteringTextInputFormatter.deny('\n')
    ];
    bool isObscureText = false;
    String labelText = '';
    if (widget.txtFieldType == LoginTextFieldType.username) {
      inputType = TextInputType.name;
      labelText = 'USERNAME';
    } else if (widget.txtFieldType == LoginTextFieldType.password ||
        widget.txtFieldType == LoginTextFieldType.newPassword ||
        widget.txtFieldType == LoginTextFieldType.confirmNewPwd) {
      inputType = TextInputType.visiblePassword;
      isObscureText = true;
      if (widget.txtFieldType == LoginTextFieldType.password) {
        labelText = 'PASSWORD';
      } else if (widget.txtFieldType == LoginTextFieldType.newPassword) {
        labelText = 'NEW PASSWORD';
      } else if (widget.txtFieldType == LoginTextFieldType.confirmNewPwd) {
        labelText = 'CONFIRM NEW PASSWORD';
      }
    } else if (widget.txtFieldType == LoginTextFieldType.mobileNumber) {
      inputType = TextInputType.phone;
      formatters.add(FilteringTextInputFormatter.digitsOnly);
      labelText = 'MOBILE NUMBER';
    }

    final screenW = MediaQuery.of(context).size.width;
    final fieldW = screenW * 0.69;

    return SizedBox(
      width: fieldW,
      height: fieldW * 0.16,
      child: TextField(
        keyboardType: inputType,
        inputFormatters: formatters,
        obscureText: isObscureText,
        cursorColor: Colors.white,
        decoration: InputDecoration(
          label: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Text(labelText),
          ),
          labelStyle: const TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w500,
            fontSize: 18,
            color: Colors.white,
          ),
          //floatingLabelAlignment: FloatingLabelAlignment.start,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 20,
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1.5),
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1.5),
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
        ),
        style: const TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w400,
          fontSize: 24,
          color: Colors.white,
        ),
      ),
    );
  }
}
