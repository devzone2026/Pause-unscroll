

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String convertToApiDate(String? displayDate) {
  if (displayDate == null || displayDate.trim().isEmpty) {
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }
  try {
    final now = DateTime.now();
    final parsed = DateFormat('EEEE, MMMM d').parse(displayDate); // ✅ EEEE not DDDD
    final withYear = DateTime(now.year, parsed.month, parsed.day);
    return DateFormat('yyyy-MM-dd').format(withYear);
  } catch (e) {
    debugPrint("convertToApiDate error: $e");
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }
}


String formatChatDate(String isoDate) {
  final date = DateTime.parse(isoDate).toLocal();
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final msgDay = DateTime(date.year, date.month, date.day);

  final timeStr = DateFormat('h:mm a').format(date); // e.g. 4:24 AM

  if (msgDay == today) {
    return 'Today at $timeStr';
  } else if (msgDay == today.subtract(const Duration(days: 1))) {
    return 'Yesterday at $timeStr';
  } else {
    return '${DateFormat('MMM d').format(date)} at $timeStr'; // e.g. Mar 29 at 4:00 PM
  }
}