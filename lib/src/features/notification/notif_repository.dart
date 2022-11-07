import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:alnabali_driver/src/features/notification/notif.dart';
import 'package:alnabali_driver/src/network/dio_client.dart';

class NotifRepository {
  NotifRepository();

  NotifList _notifs = []; //InMemoryStore<NotifList>([]);

  Future<NotifList> doFetchNotifs() async {
    if (_notifs.isNotEmpty) {
      // notifications fetched already.
      return _notifs;
    }

    final data = await DioClient.postNotificationAll();
    //developer.log('doFetchNotifs() returned: $data');

    final result = data['result'];
    if (result is List) {
      _notifs = result.map((data) => Notif.fromMap(data)).toList();
      return _notifs;
    } else {
      throw UnimplementedError;
    }
  }
}

final notificationRepositoryProvider = Provider<NotifRepository>((ref) {
  return NotifRepository();
});
