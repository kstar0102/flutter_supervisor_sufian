import 'package:alnabali_driver/src/features/auth/presentation/auth/login_controller.dart';
import 'package:alnabali_driver/src/utils/async_value_ui.dart';
import 'package:alnabali_driver/src/utils/string_hardcoded.dart';
import 'package:alnabali_driver/src/utils/string_validators.dart';
import 'package:alnabali_driver/src/widgets/login_button.dart';
import 'package:flutter/material.dart';

import 'package:alnabali_driver/src/widgets/constants.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: SizeConfig.screenW,
          height: SizeConfig.screenH,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg_normal.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                  flex: 1, child: SizedBox(height: 160 * SizeConfig.scaleY)),
              SizedBox(
                height: 497 * SizeConfig.scaleY,
                child: Image.asset("assets/images/login_icon.png"),
              ),
              Text(
                "LOGIN".hardcoded,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              Flexible(
                  flex: 1, child: SizedBox(height: 250 * SizeConfig.scaleY)),
              const LoginInputContent(),
              Flexible(
                  flex: 1, child: SizedBox(height: 310 * SizeConfig.scaleY)),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/forget_mobile');
                },
                child: Text(
                  "FORGET PASSWORD".hardcoded,
                  style: const TextStyle(
                    shadows: [
                      Shadow(color: Colors.white, offset: Offset(0, -6))
                    ],
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                    color: Colors.transparent,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white,
                    decorationThickness: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginInputContent extends ConsumerStatefulWidget {
  const LoginInputContent({super.key});

  @override
  ConsumerState<LoginInputContent> createState() => _LoginInputContentState();
}

class _LoginInputContentState extends ConsumerState<LoginInputContent> {
  final _formKey = GlobalKey<FormState>();
  final _node = FocusScopeNode();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  String get username => _usernameController.text;
  String get password => _passwordController.text;

  // local variable used to apply AutovalidateMode.onUserInteraction and show
  // error hints only when the form has been submitted
  // For more details on how this is implemented, see:
  // https://codewithandrea.com/articles/flutter-text-field-form-validation/
  var _submitted = false;

  @override
  void dispose() {
    _node.dispose();

    // TextEditingControllers should be always disposed.
    _usernameController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  Future<void> _submit(LoginState state) async {
    setState(() => _submitted = true);

    // only submit the form if validation passes
    if (_formKey.currentState!.validate()) {
      final controller = ref.read(loginControllerProvider.notifier);
      final success = await controller.submit(username, password);
      if (success) {
        //widget.onSignedIn?.call();
      }
    }
  }

  void _emailEditingComplete(LoginState state) {
    if (state.canSubmitEmail(username)) {
      _node.nextFocus();
    }
  }

  void _passwordEditingComplete(LoginState state) {
    if (!state.canSubmitEmail(username)) {
      _node.previousFocus();
      return;
    }
    _submit(state);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      loginControllerProvider.select((state) => state.value),
      (_, state) {
        state.showAlertDialogOnError(context);
        state.whenData((value) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacementNamed('/home');
          });
        });
      },
    );

    final textfieldW = SizeConfig.screenW * 0.69;
    final textfieldH = textfieldW * 0.16;

    const labelStyle = TextStyle(
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.w500,
      fontSize: 18,
      color: Colors.white,
    );
    const errorStyle = TextStyle(
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.w700,
      fontSize: 14,
    );
    const editStyle = TextStyle(
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.w400,
      fontSize: 18,
      color: Colors.white,
    );

    final contentPadding = EdgeInsets.symmetric(
      horizontal: 40 * SizeConfig.scaleX,
      vertical: 10 * SizeConfig.scaleY,
    );
    const enableBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white, width: 1.2),
      borderRadius: BorderRadius.all(Radius.circular(100)),
    );
    const focusBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white, width: 1.2),
      borderRadius: BorderRadius.all(Radius.circular(100)),
    );

    final state = ref.watch(loginControllerProvider);

    return FocusScope(
      node: _node,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: textfieldW,
              height: textfieldH,
              child: TextFormField(
                controller: _usernameController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (username) =>
                    !_submitted ? null : state.emailErrorText(username ?? ''),
                autocorrect: false,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                cursorColor: Colors.white,
                onEditingComplete: () => _emailEditingComplete(state),
                inputFormatters: <TextInputFormatter>[
                  ValidatorInputFormatter(
                      editingValidator: EmailEditingRegexValidator()),
                ],
                decoration: InputDecoration(
                  label: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Text('USERNAME'.hardcoded),
                  ),
                  labelStyle: labelStyle,
                  errorStyle: errorStyle,
                  //hintText: 'test@test.com'.hardcoded,
                  //floatingLabelAlignment: FloatingLabelAlignment.start,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  contentPadding: contentPadding,
                  enabledBorder: enableBorder,
                  focusedBorder: focusBorder,
                  focusedErrorBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  enabled: !state.isLoading,
                ),
                style: editStyle,
              ),
            ),
            Flexible(flex: 1, child: SizedBox(height: 125 * SizeConfig.scaleY)),
            SizedBox(
              width: textfieldW,
              height: textfieldH,
              child: TextFormField(
                controller: _passwordController,
                keyboardType: TextInputType.visiblePassword,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (pwd) =>
                    !_submitted ? null : state.passwordErrorText(pwd ?? ''),
                obscureText: true,
                autocorrect: false,
                textInputAction: TextInputAction.done,
                cursorColor: Colors.white,
                onEditingComplete: () => _passwordEditingComplete(state),
                decoration: InputDecoration(
                  label: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Text('PASSWORD'.hardcoded),
                  ),
                  labelStyle: labelStyle,
                  errorStyle: errorStyle,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  contentPadding: contentPadding,
                  enabledBorder: enableBorder,
                  focusedBorder: focusBorder,
                  focusedErrorBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  enabled: !state.isLoading,
                ),
                style: editStyle,
              ),
            ),
            Flexible(flex: 1, child: SizedBox(height: 260 * SizeConfig.scaleY)),
            LoginButton(
              btnType: LoginButtonType.logIn,
              isLoading: state.isLoading,
              onPressed: () {
                if (!state.isLoading) {
                  _submit(state);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
