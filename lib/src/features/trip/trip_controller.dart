import 'package:alnabali_driver/src/features/trip/trips_list_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:alnabali_driver/src/constants/app_constants.dart';
import 'package:alnabali_driver/src/features/trip/trip.dart';
import 'package:alnabali_driver/src/features/trip/trip_repository.dart';

class TripController extends StateNotifier<AsyncValue<bool>> {
  TripController({
    required this.tripRepo,
  }) : super(const AsyncData(false));

  final TripRepository tripRepo;

  Trip? getTripInfo(String tripId) {
    return tripRepo.getTripInfo(tripId);
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

final tripControllerProvider =
    StateNotifierProvider.autoDispose<TripController, AsyncValue<void>>((ref) {
  final tripKind = ref.watch(tripsKindProvider.state).state;
  if (tripKind == TripKind.today) {
    return TripController(tripRepo: ref.watch(todayTripsRepoProvider));
  } else {
    return TripController(tripRepo: ref.watch(pastTripsRepoProvider));
  }
});
