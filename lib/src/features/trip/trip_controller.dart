import 'package:alnabali_driver/src/features/trip/trips_list_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:alnabali_driver/src/constants/app_constants.dart';
import 'package:alnabali_driver/src/features/trip/trip.dart';
import 'package:alnabali_driver/src/features/trip/trips_repository.dart';

class TripController extends StateNotifier<AsyncValue<bool>> {
  TripController({
    required this.tripsRepo,
  }) : super(const AsyncData(false));

  final TripsRepository tripsRepo;

  Trip? getTripInfo(String tripId) {
    return tripsRepo.getTripInfo(tripId);
  }

  Future<bool?> doChangeTrip(
      Trip info, TripStatus targetStatus, String? extra) async {
    state = const AsyncValue.loading();
    final newState = await AsyncValue.guard(
        () => tripsRepo.doChangeTrip(info, targetStatus, extra));

    if (mounted) {
      state = newState;
    }

    return newState.value;
  }

  // * update location request must be done at behind. (silently)
  Future<bool> doUpdateLocation(double lat, double lon) async {
    final newState =
        await AsyncValue.guard(() => tripsRepo.doUpdateLocation(lat, lon));

    return newState.hasValue;
  }
}

final tripControllerProvider =
    StateNotifierProvider.autoDispose<TripController, AsyncValue<void>>((ref) {
  final tripKind = ref.watch(tripsKindProvider.state).state;
  if (tripKind == TripKind.today) {
    return TripController(tripsRepo: ref.watch(todayTripsRepoProvider));
  } else {
    return TripController(tripsRepo: ref.watch(pastTripsRepoProvider));
  }
});
