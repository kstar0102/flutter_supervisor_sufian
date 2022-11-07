// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:alnabali_driver/src/constants/app_constants.dart';
import 'package:alnabali_driver/src/utils/string_hardcoded.dart';

enum TripKind {
  today,
  past,
}

@immutable
class Trip {
  const Trip({
    required this.id,
    required this.status,
    required this.clientName,
    required this.tripName,
    required this.busNo,
    required this.busSizeId,
    required this.startDate,
    required this.endDate,
    required this.orgArea,
    required this.orgCity,
    required this.destArea,
    required this.destCity,
    required this.details,
  });

  final String id;
  final TripStatus status;
  final String clientName;
  final String tripName;
  final String busNo;
  final int busSizeId;
  // bus line data
  final DateTime startDate;
  final DateTime endDate;
  final String orgArea;
  final String orgCity;
  final String destArea;
  final String destCity;
  final String details;

  String getStatusTitle() {
    const List<String> kStatusTitles = [
      'None',
      'Pending',
      'Accepted',
      'Rejected',
      'Started',
      'Finished',
      'Canceled',
    ];
    return kStatusTitles[status.index];
  }

  String getTripTitle() => 'Trip # $id';
  String getTripTitleShort() => '# $id';

  String getStartDateStr() => DateFormat('MMM d y (E)').format(startDate);
  String getStartTimeStr() => DateFormat('hh:mm a').format(startDate);

  String getEndDateStr() => DateFormat('MMM d y (E)').format(endDate);
  String getEndTimeStr() => DateFormat('hh:mm a').format(endDate);

  String getDurationStr() {
    final Duration duration = endDate.difference(startDate);
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));

    return '${duration.inHours}:$twoDigitMinutes Min';
  }

  String getNotifyText() {
    switch (status) {
      case TripStatus.pending:
        return 'New pending trip'.hardcoded;
      case TripStatus.accepted:
        return 'Trip has been accepted'.hardcoded;
      case TripStatus.rejected:
        return 'Trip has been rejected'.hardcoded;
      case TripStatus.started:
        return 'Trip has been started'.hardcoded;
      case TripStatus.finished:
        return 'Trip has been finished'.hardcoded;
      case TripStatus.canceled:
        return 'Trip has been canceled'.hardcoded;
      default:
        return 'unknown status...'.hardcoded;
    }
  }

  factory Trip.fromMap(Map<String, dynamic> data) {
    var status = kStatusMapper[data['status']] ?? TripStatus.pending;

    return Trip(
      id: data['id'].toString(),
      status: status,
      clientName: data['client_name'],
      tripName: data['trip_name'],
      busNo: data['bus_no'],
      busSizeId: data['bus_size_id'],
      startDate: DateFormat('y-m-d h:mm a')
          .parse('${data['start_date']} ${data['start_time']}'),
      endDate: DateFormat('y-m-d h:mm a')
          .parse('${data['end_date']} ${data['end_time']}'),
      orgArea: data['origin_area'],
      orgCity: data['origin_city'],
      destArea: data['destination_area'],
      destCity: data['destination_city'],
      details: data['details'] ?? '',
    );
  }

  @override
  String toString() {
    return 'Trip(id: $id, status: $status, client: $clientName, '
        'busNo: $busNo, busSize: $busSizeId, '
        'startDate: $startDate, endDate: $endDate, '
        'org: $orgArea-$orgCity, dest: $destArea-$destCity), '
        'details: $details)';
  }
}
