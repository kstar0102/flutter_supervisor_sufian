import 'package:alnabali_driver/src/features/auth/presentation/auth/splash_controller.dart';
import 'package:alnabali_driver/src/utils/size_config.dart';
import 'package:alnabali_driver/src/utils/string_hardcoded.dart';
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
    ref.read(splashControllerProvider.notifier).fetchToken();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: showFetchingStatus(),
      ),
    );
  }

  Widget showFetchingStatus() {
    final state = ref.watch(splashControllerProvider);
    return state.when<Widget>(
      data: (d) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushReplacementNamed('/login');
        });

        return const SizedBox();
      },
      error: (e, st) => Text('Connection Failed...'.hardcoded),
      loading: () => const CircularProgressIndicator(),
    );
  }
}
