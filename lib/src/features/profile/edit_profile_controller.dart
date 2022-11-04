import 'package:alnabali_driver/src/features/auth/data/auth_old_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditProfileController extends StateNotifier<AsyncValue<void>> {
  EditProfileController({required this.authRepository})
      : super(const AsyncData<void>(null));

  final AuthOldRepository authRepository;

  Future<void> tryEditProfile(
      String name, String phone, String birthday, String address) async {
    state = const AsyncValue.loading();

    final newState = await AsyncValue.guard(
        () => authRepository.tryEditProfile(name, phone, birthday, address));

    if (mounted) {
      state = newState;
    }
  }
}

final editProfileControllerProvider =
    StateNotifierProvider.autoDispose<EditProfileController, AsyncValue<void>>(
        (ref) {
  return EditProfileController(
      authRepository: ref.watch(authRepositoryProvider));
});
