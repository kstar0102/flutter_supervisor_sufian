import 'dart:developer' as developer;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:alnabali_driver/src/constants/app_constants.dart';
import 'package:alnabali_driver/src/features/trip/trip.dart';
import 'package:alnabali_driver/src/network/dio_client.dart';
import 'package:alnabali_driver/src/utils/in_memory_store.dart';

// * ---------------------------------------------------------------------------
// * TripRepository
// * ---------------------------------------------------------------------------

class TripRepository {
  TripRepository({required this.repoType});

  final TripKind repoType;

  final _trips = InMemoryStore<TripList>([]);

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

  Future<bool> doChangeTrip(String tripId, bool isYes, String? extra) async {
    // search target trip from list.
    final searched = _trips.value.where((t) => t.id == tripId).toList();
    if (searched.isEmpty) {
      return false;
    }

    // decide command to execute for this trip.
    final targetTrip = searched.first;
    String command;
    TripStatus status = TripStatus.all;
    if (targetTrip.status == TripStatus.pending) {
      if (isYes == true) {
        command = 'accept';
        status = TripStatus.accepted;
      } else {
        command = 'reject';
        status = TripStatus.rejected;
      }
    } else if (targetTrip.status == TripStatus.accepted) {
      if (isYes == true) {
        command = 'start';
        status = TripStatus.started;
      } else {
        command = 'reject';
        status = TripStatus.rejected;
      }
    } else if (targetTrip.status == TripStatus.started) {
      if (isYes == true) {
        command = 'finish';
        status = TripStatus.finished;
      } else {
        command = 'navigation'; // ? is command?
      }
    } else {
      // no commands for this status.
      return false;
    }

    final data = await DioClient.postDailyTripCommand(targetTrip.id, command);
    developer.log('doChangeTrip() returned: $data');

    assert(status != TripStatus.all);

    final result = data['result'];
    if (result == 'Changed to $command') {
      // update target trip's status
      var index = _trips.value.indexOf(targetTrip);
      var trips = _trips.value;
      trips[index] = targetTrip.copyWith(status);
      _trips.value = trips;

      return true;
    }

    return false;
  }
}

// * ---------------------------------------------------------------------------
// * TripRepositoryProviders
// * ---------------------------------------------------------------------------

final todayTripsRepoProvider = Provider<TripRepository>((ref) {
  return TripRepository(repoType: TripKind.today);
});

final pastTripsRepoProvider = Provider<TripRepository>((ref) {
  return TripRepository(repoType: TripKind.past);
});
