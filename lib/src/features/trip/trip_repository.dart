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

  Future<void> doFetchTrips() async {
    if (_trips.value.isNotEmpty) {
      // trips fetched already.
      return;
    }

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
        developer.log('fetched trips: ${_trips.value.length}');
      } catch (e) {
        developer.log('doFetchTrips() error=$e');
      }
    } else {
      throw UnimplementedError;
    }
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
