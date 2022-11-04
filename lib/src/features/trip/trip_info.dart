import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

// trip status enum.
enum TripStatus {
  pending,
  accepted,
  rejected,
  started,
  finished,
  canceled,
}

// trip status strings.
const List<String> kTripStatusStrings = [
  'Pending',
  'Accepted',
  'Rejected',
  'Started',
  'Finished',
  'Canceled',
];

// trip status colors.
const List<Color> kTripStatusColors = [
  Color(0xFFFBB03B),
  Color(0xFFA67C52),
  Color(0xFFED1C24),
  Color(0xFF29ABE2),
  Color(0xFF39B54A),
  Color(0xFFFF00FF),
];

///-----------------------------------------------------------------------------
/// CompanyInfo
///-----------------------------------------------------------------------------

class CompanyInfo {
  final String companyName;
  final String tripName;

  CompanyInfo({
    required this.companyName,
    required this.tripName,
  });

  String getCompanyImgPath() {
    final lowerStr = companyName.toLowerCase();
    return 'assets/images/company_$lowerStr.png';
  }
}

///-----------------------------------------------------------------------------
/// BusLineInfo
///-----------------------------------------------------------------------------

class BusLineInfo {
  final DateTime fromTime;
  final DateTime toTime;
  final String courseName;
  final String cityName;
  final String courseDetail;

  BusLineInfo({
    required this.fromTime,
    required this.toTime,
    required this.courseName,
    required this.cityName,
    required this.courseDetail,
  });

  String getFromDateStr() {
    final DateFormat formatter = DateFormat('MMM d y (E)');
    return formatter.format(fromTime);
  }

  String getFromTimeStr() {
    final DateFormat formatter = DateFormat('hh:mm a');
    return formatter.format(fromTime);
  }

  String getToDateStr() {
    final DateFormat formatter = DateFormat('MMM d y (E)');
    return formatter.format(toTime);
  }

  String getToTimeStr() {
    final DateFormat formatter = DateFormat('hh:mm a');
    return formatter.format(toTime);
  }

  String getDurTimeStr() {
    final Duration duration = toTime.difference(fromTime);
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));

    return '${duration.inHours}:$twoDigitMinutes Min';
  }
}

///-----------------------------------------------------------------------------
/// TripInfo
///-----------------------------------------------------------------------------

class TripInfo {
  final TripStatus status;
  final int tripNo;
  final CompanyInfo company;
  final String busNo;
  final int passengers;
  final BusLineInfo busLine;
  final String rejectReason;

  TripInfo({
    this.status = TripStatus.pending,
    required this.tripNo,
    required this.company,
    required this.busNo,
    required this.passengers,
    required this.busLine,
    this.rejectReason = '',
  });

  String getStatusImgPath() {
    final indexStr = status.index;
    return 'assets/images/trip_status$indexStr.png';
  }

  String getStatusStr() {
    return kTripStatusStrings[status.index];
  }

  Color getStatusColor() {
    return kTripStatusColors[status.index];
  }

  String getTripNoStr() {
    return 'Trip # $tripNo';
  }

  String getTripNoStrShort() {
    return '#$tripNo';
  }

  String getNotificationStr() {
    switch (status) {
      case TripStatus.pending:
        return 'New pending trip';
      case TripStatus.accepted:
        return 'Trip has been accepted';
      case TripStatus.rejected:
        return 'Trip has been rejected';
      case TripStatus.started:
        return 'Trip has been started';
      case TripStatus.finished:
        return 'Trip has been finished';
      case TripStatus.canceled:
        return 'Trip has been canceled';
      default:
        return 'unknown status...';
    }
  }
}
