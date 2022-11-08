import 'dart:developer' as developer;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:alnabali_driver/src/constants/app_constants.dart';
import 'package:alnabali_driver/src/features/trip/trip_repository.dart';
import 'package:alnabali_driver/src/features/trip/trip.dart';

// * ---------------------------------------------------------------------------
// * TripsFilterProvider
// * ---------------------------------------------------------------------------

final todayTripsFilter = StateProvider<TripStatus>((ref) => TripStatus.all);
final pastTripsFilter = StateProvider<TripStatus>((ref) => TripStatus.all);

// * ---------------------------------------------------------------------------
// * TripsListController
// * ---------------------------------------------------------------------------

class TripsListController extends StateNotifier<AsyncValue<bool>> {
  TripsListController({
    required this.tripRepo,
  }) : super(const AsyncData(false));

  final TripRepository tripRepo;

  Future<bool?> doFetchTrips() async {
    state = const AsyncValue.loading();
    final newState = await AsyncValue.guard(() => tripRepo.doFetchTrips());

    if (mounted) {
      state = newState;
    }

    return newState.value;
  }

  Future<bool?> doChangeTrip(
      Trip info, TripStatus targetStatus, String? extra) async {
    state = const AsyncValue.loading();
    final newState = await AsyncValue.guard(
        () => tripRepo.doChangeTrip(info, targetStatus, extra));

    if (mounted) {
      state = newState;
    }

    return newState.value;
  }
}

// * ---------------------------------------------------------------------------
// * TripsListControllerProviders
// * ---------------------------------------------------------------------------

final todayTripListCtrProvider =
    StateNotifierProvider.autoDispose<TripsListController, AsyncValue<void>>(
        (ref) {
  return TripsListController(tripRepo: ref.watch(todayTripsRepoProvider));
});

final pastTripListCtrProvider =
    StateNotifierProvider.autoDispose<TripsListController, AsyncValue<void>>(
        (ref) {
  return TripsListController(tripRepo: ref.watch(pastTripsRepoProvider));
});

// * ---------------------------------------------------------------------------
// * FilteredTripsProviders
// * ---------------------------------------------------------------------------

final todayFilteredTripsProvider = StreamProvider.autoDispose<TripList>((ref) {
  final filter = ref.watch(todayTripsFilter);
  developer.log('today filter=$filter');
  return ref.watch(todayTripsRepoProvider).watchFilterTrips(filter);
});

final pastFilteredTripsProvider = StreamProvider.autoDispose<TripList>((ref) {
  final filter = ref.watch(pastTripsFilter);
  developer.log('past filter=$filter');
  return ref.watch(pastTripsRepoProvider).watchFilterTrips(filter);
});
