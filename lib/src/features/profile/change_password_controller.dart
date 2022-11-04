import 'package:alnabali_driver/src/features/auth/data/auth_old_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChangePasswordController extends StateNotifier<AsyncValue<void>> {
  ChangePasswordController({required this.authRepository})
      : super(const AsyncData<void>(null));

  final AuthOldRepository authRepository;

  Future<void> tryChangePwd(String currPwd, String newPwd) async {
    state = const AsyncValue.loading();

    final newState = await AsyncValue.guard(
        () => authRepository.tryChangePwd(currPwd, newPwd));

    if (mounted) {
      state = newState;
    }
  }
}

final changePwdControllerProvider = StateNotifierProvider.autoDispose<
    ChangePasswordController, AsyncValue<void>>((ref) {
  return ChangePasswordController(
      authRepository: ref.watch(authRepositoryProvider));
});
