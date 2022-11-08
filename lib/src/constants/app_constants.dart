import 'package:flutter/material.dart';

enum TripStatus {
  all,
  pending,
  accepted,
  rejected,
  started,
  finished,
  canceled,
}

const kStatusMapper = {
  '1': TripStatus.pending,
  '2': TripStatus.accepted,
  '3': TripStatus.rejected,
  '4': TripStatus.started,
  '6': TripStatus.finished,
  '8': TripStatus.canceled,
};

Color getStatusColor(TripStatus status) {
  const List<Color> kStatusColors = [
    Colors.black,
    Color(0xFFFBB03B),
    Color(0xFFA67C52),
    Color(0xFFED1C24),
    Color(0xFF29ABE2),
    Color(0xFF39B54A),
    Color(0xFFFF00FF),
  ];
  return kStatusColors[status.index];
}
