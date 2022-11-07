import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:alnabali_driver/src/constants/app_constants.dart';
import 'package:alnabali_driver/src/features/trip/trip.dart';
import 'package:alnabali_driver/src/network/dio_client.dart';
import 'package:alnabali_driver/src/utils/in_memory_store.dart';

// * ---------------------------------------------------------------------------
// * TripsFilterProvider
// * ---------------------------------------------------------------------------

final todayTripsFilter = StateProvider<TripStatus>((ref) => TripStatus.all);
final pastTripsFilter = StateProvider<TripStatus>((ref) => TripStatus.all);

// * ---------------------------------------------------------------------------
// * TripsRepository
// * ---------------------------------------------------------------------------

abstract class TripsRepository {
  Stream<List<Trip>> tripsChanges();

  Future<void> doFetchTrips();
}

// * ---------------------------------------------------------------------------
// * TodayTripsRepository
// * ---------------------------------------------------------------------------

class TodayTripsRepository implements TripsRepository {
  TodayTripsRepository();

  final _trips = InMemoryStore<List<Trip>>([]);

  @override
  Stream<List<Trip>> tripsChanges() => _trips.stream;

  @override
  Future<void> doFetchTrips() async {
    final data = await DioClient.postDailyTripToday();
    //developer.log('doFetchTrips() returned: $data');

    final result = data['result'];
    if (result is List) {
      _trips.value = result.map((data) => Trip.fromMap(data)).toList();
    } else {
      throw UnimplementedError;
    }
  }
}

final todayTripsRepoProvider = Provider<TripsRepository>((ref) {
  return TodayTripsRepository();
});

final todayTripsChangesProvider = StreamProvider<List<Trip>>((ref) {
  return ref.watch(todayTripsRepoProvider).tripsChanges();
});

// * ---------------------------------------------------------------------------
// * PastTripsRepository
// * ---------------------------------------------------------------------------

class PastTripsRepository implements TripsRepository {
  PastTripsRepository();

  final _trips = InMemoryStore<List<Trip>>([]);

  @override
  Stream<List<Trip>> tripsChanges() => _trips.stream;

  @override
  Future<void> doFetchTrips() async {
    final data = await DioClient.postDailyTripLast();
    //developer.log('doFetchTrips() returned: $data');

    final result = data['result'];
    if (result is List) {
      _trips.value = result.map((data) => Trip.fromMap(data)).toList();
    } else {
      throw UnimplementedError;
    }
  }
}

final pastTripsRepoProvider = Provider<TripsRepository>((ref) {
  return PastTripsRepository();
});

final pastTripsChangesProvider = StreamProvider<List<Trip>>((ref) {
  return ref.watch(pastTripsRepoProvider).tripsChanges();
});
