import 'package:hive_flutter/hive_flutter.dart';

class LocalStorage {
  static const String _notesBox = 'notes';
  static const String _messagesBox = 'messages';
  static const String _analyticsBox = 'analytics';
  static const String _syncQueueBox = 'sync_queue';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(_notesBox);
    await Hive.openBox(_messagesBox);
    await Hive.openBox(_analyticsBox);
    await Hive.openBox(_syncQueueBox);
  }

  // Notes operations
  Box get notesBox => Hive.box(_notesBox);
  
  Future<void> saveNote(String id, Map<String, dynamic> note) async {
    await notesBox.put(id, note);
  }

  Map<String, dynamic>? getNote(String id) {
    final data = notesBox.get(id);
    return data != null ? Map<String, dynamic>.from(data) : null;
  }

  List<Map<String, dynamic>> getAllNotes() {
    return notesBox.values
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  Future<void> deleteNote(String id) async {
    await notesBox.delete(id);
  }

  // Messages operations
  Box get messagesBox => Hive.box(_messagesBox);

  Future<void> saveMessage(String id, Map<String, dynamic> message) async {
    await messagesBox.put(id, message);
  }

  List<Map<String, dynamic>> getAllMessages() {
    return messagesBox.values
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  // Analytics operations
  Box get analyticsBox => Hive.box(_analyticsBox);

  Future<void> saveAnalytics(Map<String, dynamic> data) async {
    await analyticsBox.put('current', data);
  }

  Map<String, dynamic>? getAnalytics() {
    final data = analyticsBox.get('current');
    return data != null ? Map<String, dynamic>.from(data) : null;
  }

  // Sync queue operations
  Box get syncQueueBox => Hive.box(_syncQueueBox);

  Future<void> addToSyncQueue(Map<String, dynamic> action) async {
    final key = DateTime.now().millisecondsSinceEpoch.toString();
    await syncQueueBox.put(key, action);
  }

  List<MapEntry<dynamic, Map<String, dynamic>>> getSyncQueue() {
    return syncQueueBox.toMap().entries
        .map((e) => MapEntry(e.key, Map<String, dynamic>.from(e.value)))
        .toList();
  }

  Future<void> removeSyncItem(dynamic key) async {
    await syncQueueBox.delete(key);
  }

  Future<void> clearAll() async {
    await notesBox.clear();
    await messagesBox.clear();
    await analyticsBox.clear();
    await syncQueueBox.clear();
  }
}