import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'local_storage.dart';

class SyncManager {
  final LocalStorage _storage;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription? _connectivitySubscription;
  bool _isOnline = false;

  SyncManager(this._storage);

  Future<void> init() async {
    final result = await _connectivity.checkConnectivity();
    _isOnline = result != ConnectivityResult.none;

    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (ConnectivityResult result) {
        final wasOffline = !_isOnline;
        _isOnline = result != ConnectivityResult.none;
        
        // Trigger sync when coming back online
        if (wasOffline && _isOnline) {
          syncPendingActions();
        }
      },
    );
  }

  bool get isOnline => _isOnline;

  Future<void> queueAction(String type, Map<String, dynamic> data) async {
    await _storage.addToSyncQueue({
      'type': type,
      'data': data,
      'timestamp': DateTime.now().toIso8601String(),
      'retries': 0,
    });

    if (_isOnline) {
      syncPendingActions();
    }
  }

  Future<void> syncPendingActions() async {
    if (!_isOnline) return;

    final queue = _storage.getSyncQueue();
    
    for (final entry in queue) {
      try {
        final action = entry.value;
        final type = action['type'];
        
        // Mocking sync here - in a real app, I'll make API calls instead
        await _mockSync(type, action['data']);
        
        await _storage.removeSyncItem(entry.key);
      } catch (e) {
        final action = entry.value;
        action['retries'] = (action['retries'] ?? 0) + 1;
        
        if (action['retries'] > 3) {
          await _storage.removeSyncItem(entry.key);
        }
      }
    }
  }

  Future<void> _mockSync(String type, Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 500));
    debugPrint('Synced $type: $data');
  }

  void dispose() {
    _connectivitySubscription?.cancel();
  }
}
