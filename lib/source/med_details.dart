//import 'package:flutter/material.dart';

// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:med_remainder/functions.dart';

class Medicine {
  String? name;
  String? dosage;
  String? time;
  String? duration;
  DateTime? startdate;

  Medicine({
    required this.name,
    required this.dosage,
    required this.time,
    required this.duration,
    required this.startdate,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      name: json['name'],
      dosage: json['dosage'],
      time: json['time'],
      duration: json['duration'],
      startdate: json['startdate'] != null ? DateTime.parse(json['startdate']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dosage': dosage,
      'time': time,
      'duration': duration,
      'startdate': startdate?.toIso8601String(),
    };
  }
}

int? no;










