import 'dart:developer' as developer;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:alnabali_driver/src/constants/app_constants.dart';
import 'package:alnabali_driver/src/features/trip/trip_repository.dart';
import 'package:alnabali_driver/src/features/trip/trip.dart';

// * ---------------------------------------------------------------------------
// * TripsFilterProviders
// * ---------------------------------------------------------------------------

final tripsKindProvider = StateProvider<TripKind>((ref) => TripKind.today);
final todayFilterProvider = StateProvider<TripStatus>((ref) => TripStatus.all);
final pastFilterProvider = StateProvider<TripStatus>((ref) => TripStatus.all);

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

  Trip? getTripInfo(String tripId) {
    return tripRepo.getTripInfo(tripId);
  }
}

// * ---------------------------------------------------------------------------
// * TripsListControllerProviders
// * ---------------------------------------------------------------------------

final todayTripsListCtrProvider =
    StateNotifierProvider.autoDispose<TripsListController, AsyncValue<bool>>(
        (ref) {
  return TripsListController(tripRepo: ref.watch(todayTripsRepoProvider));
});

final pastTripsListCtrProvider =
    StateNotifierProvider.autoDispose<TripsListController, AsyncValue<bool>>(
        (ref) {
  return TripsListController(tripRepo: ref.watch(pastTripsRepoProvider));
});

// * ---------------------------------------------------------------------------
// * FilteredTripsProviders
// * ---------------------------------------------------------------------------

final todayFilteredTripsProvider = StreamProvider.autoDispose<TripList>((ref) {
  final filter = ref.watch(todayFilterProvider);
  developer.log('today filter=$filter');
  return ref.watch(todayTripsRepoProvider).watchFilterTrips(filter);
});

final pastFilteredTripsProvider = StreamProvider.autoDispose<TripList>((ref) {
  final filter = ref.watch(pastFilterProvider);
  developer.log('past filter=$filter');
  return ref.watch(pastTripsRepoProvider).watchFilterTrips(filter);
});
