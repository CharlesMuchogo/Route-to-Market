import 'dart:ui';

import 'package:intl/intl.dart';

String getCompanyInitials(String name) {
  final words = name.split(' ');
  if (words.length >= 2) {
    return '${words[0][0]}${words[1][0]}'.toUpperCase();
  } else if (words.isNotEmpty) {
    return words[0].substring(0, words[0].length >= 2 ? 2 : 1).toUpperCase();
  }
  return 'C';
}

Color getAvatarColor(int id) {
  final colors = [
    const Color(0xFF3B82F6), // blue
    const Color(0xFF8B5CF6), // purple
    const Color(0xFF10B981), // green
    const Color(0xFFEF4444), // red
    const Color(0xFFF59E0B), // yellow
    const Color(0xFF6366F1), // indigo
    const Color(0xFFEC4899), // pink
    const Color(0xFF14B8A6), // teal
  ];
  return colors[id % colors.length];
}

Color getActivityAvatarColor(int id) {
  final colors = [
    const Color(0xFFFCCDAC),
    const Color(0xFFAE7F62),
    const Color(0xFF613D28),
    const Color(0xFF231810),
    const Color(0xFF080808),
    const Color(0xFF625F5D)
  ];
  return colors[id % colors.length];
}

String formatDate(DateTime date) {
  return DateFormat('MMM d, y').format(date);
}

String formatDateTime(DateTime date) {
  return DateFormat('MMM d, y hh:mm').format(date);
}

enum ConnectionType {
  Wifi,
  Mobile,
}