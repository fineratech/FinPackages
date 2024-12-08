// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AvailabilityModel {
  final DateTime startDateTime;
  final DateTime endDateTime;
  AvailabilityModel({
    required this.startDateTime,
    required this.endDateTime,
  });

  TimeOfDay get startTime => TimeOfDay.fromDateTime(startDateTime);
  TimeOfDay get endTime => TimeOfDay.fromDateTime(endDateTime);

  AvailabilityModel copyWith({
    DateTime? startDateTime,
    DateTime? endDateTime,
  }) {
    return AvailabilityModel(
      startDateTime: startDateTime ?? this.startDateTime,
      endDateTime: endDateTime ?? this.endDateTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'startDateTime': startDateTime.millisecondsSinceEpoch,
      'endDateTime': endDateTime.millisecondsSinceEpoch,
    };
  }

  factory AvailabilityModel.fromMap(Map<String, dynamic> map) {
    return AvailabilityModel(
      startDateTime: DateFormat('dd/MM/yyyy hh:mm').parse(map['StartTime']),
      endDateTime: DateFormat('dd/MM/yyyy hh:mm').parse(map['EndTime']),
    );
  }

  String toJson() => json.encode(toMap());

  factory AvailabilityModel.fromJson(String source) =>
      AvailabilityModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'AvailabilityModel(startDateTime: $startDateTime, endDateTime: $endDateTime)';

  @override
  bool operator ==(covariant AvailabilityModel other) {
    if (identical(this, other)) return true;

    return other.startDateTime == startDateTime &&
        other.endDateTime == endDateTime;
  }

  @override
  int get hashCode => startDateTime.hashCode ^ endDateTime.hashCode;
}
