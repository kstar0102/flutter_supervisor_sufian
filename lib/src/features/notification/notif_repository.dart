import 'dart:developer' as developer;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:alnabali_driver/src/features/notification/notif.dart';
import 'package:alnabali_driver/src/network/dio_client.dart';
import 'package:alnabali_driver/src/utils/in_memory_store.dart';

class NotifRepository {
  NotifRepository();

  final _notifications = InMemoryStore<List<Notif>>([]);

  Stream<List<Notif>> watchNotifications() {
    return _notifications.stream.map((notis) {
      notis.sort((lhs, rhs) => rhs.notifyDate.compareTo(lhs.notifyDate));
      return notis;
    });
  }

  Future<void> doFetchNotifs() async {
    final data = await DioClient.postNotificationAll();
    developer.log('doGetProfile() returned: $data');

    final result = data['result'];
    if (result is List) {
      _notifications.value = result.map((data) => Notif.fromMap(data)).toList();
    } else {
      throw UnimplementedError;
    }
  }
}

final notificationRepositoryProvider = Provider<NotifRepository>((ref) {
  return NotifRepository();
});

final notificationsProvider = StreamProvider.autoDispose<List<Notif>>((ref) {
  return ref.watch(notificationRepositoryProvider).watchNotifications();
});
