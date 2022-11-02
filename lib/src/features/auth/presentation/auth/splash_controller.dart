import 'package:alnabali_driver/src/features/auth/data/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashController extends StateNotifier<AsyncValue<void>> {
  SplashController({required this.authRepository})
      : super(const AsyncData<void>(null));

  final AuthRepository authRepository;

  Future<void> fetchToken() async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard<void>(
      () => authRepository.fetchToken(),
    );

    //if (state.hasError) print('error');
  }
}

final splashControllerProvider =
    // StateNotifierProvider takes the controller class and state class as type arguments
    StateNotifierProvider.autoDispose<SplashController, AsyncValue<void>>(
        (ref) {
  return SplashController(
    authRepository: ref.watch(authRepositoryProvider),
  );
});
