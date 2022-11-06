import 'dart:developer' as developer;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:alnabali_driver/src/features/profile/profile_repository.dart';
import 'package:alnabali_driver/src/features/trip/trip.dart';
import 'package:alnabali_driver/src/network/dio_client.dart';
import 'package:alnabali_driver/src/utils/in_memory_store.dart';

// * ---------------------------------------------------------------------------
// * TripsFilterProvider
// * ---------------------------------------------------------------------------

final todayTripsFilterProvider =
    StateProvider<TripStatus>((ref) => TripStatus.all);

final pastTripsFilterProvider =
    StateProvider<TripStatus>((ref) => TripStatus.all);

// * ---------------------------------------------------------------------------
// * TripsRepository
// * ---------------------------------------------------------------------------

enum TripsRepoType {
  today,
  past,
}

class TripsRepository {
  TripsRepository({
    required this.repoType,
    required this.filter,
    required this.profileRepo,
  });

  final TripsRepoType repoType;
  final TripStatus filter;
  final ProfileRepository profileRepo; // ! later, use for driver_name

  final _tripsState = InMemoryStore<List<Trip>?>([]);

  Stream<List<Trip>?> tripsStateChanges() {
    return _tripsState.stream;
    // return _tripsState.stream.map((tripsData) {
    //   print('filter = $filter, trips=${tripsData?.length}');
    //   if (tripsData != null) {
    //     if (filter == TripStatus.all) {
    //       return tripsData;
    //     } else {
    //       return tripsData.where((trip) => trip.status == filter).toList();
    //     }
    //   }

    //   return [];
    // });
  }

  Future<void> doFetchTrips() async {
    final data = await DioClient.postDailyTrip(repoType == TripsRepoType.today);
    //developer.log('doFetchTrips() returned: $data'); // too long...

    var result = data['result'];
    if (result is List) {
      developer.log('doFetchTrips() returned: ${result.length}');

      try {
        _tripsState.value = result.map((data) => Trip.fromMap(data)).toList();
      } catch (e) {
        //print(e);
      }
    } else {
      throw UnimplementedError;
    }
  }
}

// * ---------------------------------------------------------------------------
// * TripsRepositoryProvider, TripsStateChangesProvider
// * ---------------------------------------------------------------------------

final todayTripsRepoProvider = Provider<TripsRepository>((ref) {
  return TripsRepository(
    repoType: TripsRepoType.today,
    profileRepo: ref.watch(profileRepositoryProvider),
    filter: ref.watch(todayTripsFilterProvider),
  );
});

final todayTripsStateChangesProvider = StreamProvider<List<Trip>?>((ref) {
  return ref.watch(todayTripsRepoProvider).tripsStateChanges();
});

final pastTripsRepoProvider = Provider<TripsRepository>((ref) {
  return TripsRepository(
    repoType: TripsRepoType.past,
    profileRepo: ref.watch(profileRepositoryProvider),
    filter: ref.watch(pastTripsFilterProvider),
  );
});

final pastTripsStateChangesProvider = StreamProvider<List<Trip>?>((ref) {
  return ref.watch(pastTripsRepoProvider).tripsStateChanges();
});
