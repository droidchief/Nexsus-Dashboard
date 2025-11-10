import 'dart:math';
import '../../../../core/storage/local_storage.dart';
import '../../domain/entities/analytics_data.dart';
import '../../domain/repositories/analytics_repository.dart';
import '../models/analytics_model.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final LocalStorage _storage;

  AnalyticsRepositoryImpl(this._storage);

  @override
  Future<AnalyticsData> getAnalytics() async {
    final cached = _storage.getAnalytics();
    if (cached != null) {
      return AnalyticsModel.fromJson(cached);
    }

    return await refreshAnalytics();
  }

  @override
  Future<AnalyticsData> refreshAnalytics() async {
    final notes = _storage.getAllNotes();
    final messages = _storage.getAllMessages();

    // Calculate activity by day (mock data for demonstration)
    final activityByDay = _generateActivityByDay();

    // Calculate storage (mock estimation)
    final storageUsed = _calculateStorageUsed(notes.length, messages.length);

    final analytics = AnalyticsData(
      totalNotes: notes.length,
      totalMessages: messages.length,
      activeModules: 3, // Notes, Chat, Analytics
      storageUsed: storageUsed,
      lastSync: DateTime.now(),
      activityByDay: activityByDay,
    );

    final model = AnalyticsModel.fromEntity(analytics);
    await _storage.saveAnalytics(model.toJson());

    return analytics;
  }

  Map<String, int> _generateActivityByDay() {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final random = Random();
    
    return Map.fromEntries(
      days.map((day) => MapEntry(day, random.nextInt(20) + 5)),
    );
  }

  double _calculateStorageUsed(int notesCount, int messagesCount) {
    // Mock calculation: ~1KB per note, ~500B per message
    final bytes = (notesCount * 1024) + (messagesCount * 512);
    return bytes / (1024 * 1024); // Convert to MB
  }
}
