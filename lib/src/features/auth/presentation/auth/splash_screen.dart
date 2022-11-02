import 'package:alnabali_driver/src/features/auth/presentation/auth/splash_controller.dart';
import 'package:alnabali_driver/src/utils/async_value_ui.dart';
import 'package:alnabali_driver/src/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      body: SizedBox.expand(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg_splash.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 500 * SizeConfig.scaleY),
              SizedBox(
                height: 414 * SizeConfig.scaleY,
                child: Image.asset('assets/images/icon.png'),
              ),
              const TokenGetterWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class TokenGetterWidget extends ConsumerStatefulWidget {
  const TokenGetterWidget({super.key});

  @override
  ConsumerState<TokenGetterWidget> createState() => _TokenGetterWidgetState();
}

class _TokenGetterWidgetState extends ConsumerState<TokenGetterWidget> {
  @override
  void initState() {
    super.initState();

    //* start fetch-token action.
    ref.read(splashControllerProvider.notifier).tryGetToken();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      splashControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );

    final state = ref.watch(splashControllerProvider);

    return Expanded(
      child: Center(
        child: state.isLoading
            ? const CircularProgressIndicator()
            : const SizedBox(),
      ),
    );
  }
}
