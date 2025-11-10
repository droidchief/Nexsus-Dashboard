import 'package:equatable/equatable.dart';

class AnalyticsData extends Equatable {
  final int totalNotes;
  final int totalMessages;
  final int activeModules;
  final double storageUsed; // MB
  final DateTime lastSync;
  final Map<String, int> activityByDay; // Day of week -> count

  const AnalyticsData({
    required this.totalNotes,
    required this.totalMessages,
    required this.activeModules,
    required this.storageUsed,
    required this.lastSync,
    required this.activityByDay,
  });

  @override
  List<Object?> get props => [
    totalNotes,
    totalMessages,
    activeModules,
    storageUsed,
    lastSync,
    activityByDay,
  ];
}