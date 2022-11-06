import 'package:alnabali_driver/src/features/trip/trips_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// * ---------------------------------------------------------------------------
// * TripsListController
// * ---------------------------------------------------------------------------

class TripsListController extends StateNotifier<AsyncValue<void>> {
  TripsListController({
    required this.tripsRepo,
  }) : super(const AsyncData(null));

  final TripsRepository tripsRepo;

  Future<void> doFetchTrips() async {
    state = const AsyncValue.loading();

    final newState = await AsyncValue.guard(() => tripsRepo.doFetchTrips());

    if (mounted) {
      state = newState;
    }
  }
}

final todayTripsListCtrProvider =
    StateNotifierProvider.autoDispose<TripsListController, AsyncValue<void>>(
        (ref) {
  return TripsListController(tripsRepo: ref.watch(todayTripsRepoProvider));
});

final pastTripsListCtrProvider =
    StateNotifierProvider.autoDispose<TripsListController, AsyncValue<void>>(
        (ref) {
  return TripsListController(tripsRepo: ref.watch(pastTripsRepoProvider));
});
