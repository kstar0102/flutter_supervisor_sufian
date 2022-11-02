import 'package:alnabali_driver/src/features/auth/data/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashController extends StateNotifier<AsyncValue<void>> {
  SplashController({required this.authRepository})
      : super(const AsyncData<void>(null));

  final AuthRepository authRepository;

  Future<void> tryGetToken() async {
    state = const AsyncValue.loading();
    final newState = await AsyncValue.guard(authRepository.tryGetToken);

    // * Check if the controller is mounted before setting the state to prevent:
    // * Bad state: Tried to use Controller after `dispose` was called.
    if (mounted) {
      state = newState;
    }
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
