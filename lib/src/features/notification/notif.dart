import 'package:intl/intl.dart';

import 'package:alnabali_driver/src/constants/app_constants.dart';

// * ---------------------------------------------------------------------------
// * Notification Model
// * ---------------------------------------------------------------------------

class Notif {
  const Notif({
    required this.id,
    required this.tripId,
    required this.tripName,
    required this.clientName,
    required this.orgName,
    required this.destName,
    required this.message,
    required this.driverName,
    required this.status,
    required this.notifyDate,
    required this.clientAvatar,
  });

  final String id;
  final String tripId;
  final String tripName;
  final String clientName;
  final String orgName;
  final String destName;
  final String message;
  final DateTime notifyDate;
  final String driverName;
  final TripStatus status;
  final String clientAvatar;

  String getNotifTitle() => '#$tripId';
  String getNotifyTimeText() => DateFormat('hh:mm a').format(notifyDate);

  factory Notif.fromMap(Map<String, dynamic> data) {
    var status = kStatusMapper[data['status']] ?? TripStatus.pending;

    return Notif(
      id: data['id'].toString(),
      tripId: data['trip_id'].toString(),
      tripName: data['trip_name'],
      clientName: data['client_name'],
      orgName: data['origin_name'],
      destName: data['destination_name'],
      message: data['message'] ?? '',
      notifyDate: DateFormat('y-m-dd').parse('${data['updated_at']}'),
      driverName: data['driver_name'].toString(),
      status: status,
      clientAvatar: data['client_avatar'],
    );
  }

  @override
  String toString() => 'Notification(id: $id, tripId: $tripId, '
      'status: $status, message: $message, date: $notifyDate, driverName: $driverName)';
}

typedef NotifList = List<Notif>;
