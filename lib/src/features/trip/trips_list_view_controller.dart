import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:alnabali_driver/src/features/trip/trips_repository.dart';

// * ---------------------------------------------------------------------------
// * TripsListViewController
// * ---------------------------------------------------------------------------

class TripsListViewController extends StateNotifier<AsyncValue<void>> {
  TripsListViewController({
    required this.tripsRepo,
  }) : super(const AsyncData(null));

  final TripsRepository tripsRepo;

  Future<void> doFetchTrips() async {
    state = const AsyncValue.loading();

    final newState = await AsyncValue.guard(() => tripsRepo.doFetchTrips());

    //if (mounted) {
    state = newState;
    //}
  }
}

// * ---------------------------------------------------------------------------
// * TripsListViewControllers
// * ---------------------------------------------------------------------------

final todayTripsListCtrProvider = StateNotifierProvider.autoDispose<
    TripsListViewController, AsyncValue<void>>((ref) {
  return TripsListViewController(tripsRepo: ref.watch(todayTripsRepoProvider));
});

final pastTripsListCtrProvider = StateNotifierProvider.autoDispose<
    TripsListViewController, AsyncValue<void>>((ref) {
  return TripsListViewController(tripsRepo: ref.watch(pastTripsRepoProvider));
});
