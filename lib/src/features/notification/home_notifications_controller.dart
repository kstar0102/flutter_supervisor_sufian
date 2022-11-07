import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:alnabali_driver/src/features/notification/notif_repository.dart';

class HomeNotificationsController extends StateNotifier<AsyncValue<void>> {
  HomeNotificationsController({required this.notifRepo})
      : super(const AsyncData(null));

  final NotifRepository notifRepo;

  Future<void> doFetchNotifs() async {
    //if (notifRepo.currProfile != null) {
    //  return; // already profile data fetched!
    //}

    state = const AsyncValue.loading();
    final newState = await AsyncValue.guard(() => notifRepo.doFetchNotifs());
    if (mounted) state = newState;
  }
}

final homeNotificationsCtrProvider = StateNotifierProvider.autoDispose<
    HomeNotificationsController, AsyncValue<void>>((ref) {
  return HomeNotificationsController(
      notifRepo: ref.watch(notificationRepositoryProvider));
});
