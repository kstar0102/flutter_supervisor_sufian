import 'package:alnabali_driver/src/features/auth/data/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeAccountController extends StateNotifier<AsyncValue<void>> {
  HomeAccountController({required this.authRepository})
      : super(const AsyncData<void>(null));

  final AuthRepository authRepository;

  Future<void> tryGetProfile() async {
    state = const AsyncValue.loading();

    final newState =
        await AsyncValue.guard(() => authRepository.tryGetProfile());

    if (mounted) {
      state = newState;
    }
  }
}

final accountControllerProvider =
    StateNotifierProvider.autoDispose<HomeAccountController, AsyncValue<void>>(
        (ref) {
  return HomeAccountController(
      authRepository: ref.watch(authRepositoryProvider));
});
