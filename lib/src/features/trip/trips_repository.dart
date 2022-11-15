import 'dart:developer' as developer;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:alnabali_driver/src/constants/app_constants.dart';
import 'package:alnabali_driver/src/features/auth/auth_repository.dart';
import 'package:alnabali_driver/src/features/trip/trip.dart';
import 'package:alnabali_driver/src/network/dio_client.dart';
import 'package:alnabali_driver/src/utils/in_memory_store.dart';

// * ---------------------------------------------------------------------------
// * TripRepository
// * ---------------------------------------------------------------------------

class TripsRepository {
  TripsRepository({
    required this.authRepo,
    required this.repoType,
  });

  final AuthRepository authRepo;

  final TripKind repoType;
  final _trips = InMemoryStore<TripList>([]);

  Trip? getTripInfo(String tripId) {
    final searched = _trips.value.where((t) => t.id == tripId).toList();
    if (searched.isEmpty) return null;

    return searched.first;
  }

  Stream<TripList> watchFilterTrips(TripStatus filter) {
    return _trips.stream.map((tripsData) {
      if (filter == TripStatus.all) {
        return tripsData;
      } else {
        return tripsData.where((t) => t.status == filter).toList();
      }
    });
  }

  Future<bool> doFetchTrips() async {
    //if (_trips.value.isNotEmpty) {
    //  // trips fetched already.
    //  return;
    //}

    dynamic data;
    if (repoType == TripKind.today) {
      data = await DioClient.postDailyTripToday();
    } else {
      data = await DioClient.postDailyTripLast();
    }
    //developer.log('doFetchTrips() returned: $data');

    final result = data['result'];
    if (result is List) {
      try {
        _trips.value = result.map((data) => Trip.fromMap(data)).toList();
        developer.log('fetched $repoType trips: ${_trips.value.length}');
      } catch (e) {
        developer.log('doFetchTrips() error=$e');
      }

      return true;
    } else {
      throw UnimplementedError;
    }
  }

  Future<bool> doChangeTrip(
      Trip target, TripStatus targetStatus, String? extra) async {
    // search target trip from list.
    final searched = _trips.value.where((t) => t.id == target.id).toList();
    if (searched.isEmpty) {
      return false;
    }

    // decide command to execute for this trip.
    String command;
    if (targetStatus == TripStatus.accepted) {
      command = 'accept';
    } else if (targetStatus == TripStatus.rejected) {
      command = 'reject';
    } else if (targetStatus == TripStatus.started) {
      command = 'start';
    } else if (targetStatus == TripStatus.finished) {
      command = 'finish';
    } else if (targetStatus == TripStatus.canceled) {
      command = 'cancel';
    } else {
      return false;
    }

    final data = await DioClient.postDailyTripCommand(target.id, command);
    developer.log('doChangeTrip() returned: $data');

    final result = data['result'];
    if (result == 'Changed to $command') {
      // update target trip's status
      var index = _trips.value.indexOf(searched.first);
      var trips = _trips.value;
      trips[index] = searched.first.copyWith(targetStatus);
      _trips.value = trips;

      return true;
    }

    return false;
  }

  Future<bool> doUpdateLocation(double lat, double lon) async {
    final data = await DioClient.postDriverLocUpdate(authRepo.uid!, lat, lon);
    developer.log('doUpdateLocation() returned: $data');

    var result = data['result'];
    if (result == 'success') {
      //developer.log('Updated driver location to server.');
      return true;
    } else {
      //developer.log('Failed to updated driver location to server.');
    }

    return false;
  }
}

// * ---------------------------------------------------------------------------
// * TripRepositoryProviders
// * ---------------------------------------------------------------------------

final todayTripsRepoProvider = Provider<TripsRepository>((ref) {
  return TripsRepository(
    authRepo: ref.watch(authRepositoryProvider),
    repoType: TripKind.today,
  );
});

final pastTripsRepoProvider = Provider<TripsRepository>((ref) {
  return TripsRepository(
    authRepo: ref.watch(authRepositoryProvider),
    repoType: TripKind.past,
  );
});