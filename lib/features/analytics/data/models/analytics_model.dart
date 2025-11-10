import '../../domain/entities/analytics_data.dart';

class AnalyticsModel extends AnalyticsData {
  const AnalyticsModel({
    required super.totalNotes,
    required super.totalMessages,
    required super.activeModules,
    required super.storageUsed,
    required super.lastSync,
    required super.activityByDay,
  });

  factory AnalyticsModel.fromJson(Map<String, dynamic> json) {
    return AnalyticsModel(
      totalNotes: json['totalNotes'] as int,
      totalMessages: json['totalMessages'] as int,
      activeModules: json['activeModules'] as int,
      storageUsed: (json['storageUsed'] as num).toDouble(),
      lastSync: DateTime.parse(json['lastSync'] as String),
      activityByDay: Map<String, int>.from(json['activityByDay']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalNotes': totalNotes,
      'totalMessages': totalMessages,
      'activeModules': activeModules,
      'storageUsed': storageUsed,
      'lastSync': lastSync.toIso8601String(),
      'activityByDay': activityByDay,
    };
  }

  factory AnalyticsModel.fromEntity(AnalyticsData data) {
    return AnalyticsModel(
      totalNotes: data.totalNotes,
      totalMessages: data.totalMessages,
      activeModules: data.activeModules,
      storageUsed: data.storageUsed,
      lastSync: data.lastSync,
      activityByDay: data.activityByDay,
    );
  }
}