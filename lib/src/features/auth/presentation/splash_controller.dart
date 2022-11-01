import 'package:alnabali_driver/src/features/auth/data/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashController extends StateNotifier<AsyncValue<void>> {
  SplashController({required this.authRepository})
      : super(const AsyncData<void>(null));

  final AuthRepository authRepository;

  Future<void> fetchToken() async {
    // set the state to loading
    state = const AsyncLoading<void>();

    // call authRepository.fetchToken and await for the result
    state = await AsyncValue.guard<void>(
      () => authRepository.fetchToken(),
    );
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
