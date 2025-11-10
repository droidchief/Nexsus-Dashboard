import 'package:equatable/equatable.dart';

enum MessageRole { user, assistant }

class Message extends Equatable {
  final String id;
  final String content;
  final MessageRole role;
  final DateTime timestamp;
  final bool isSynced;

  const Message({
    required this.id,
    required this.content,
    required this.role,
    required this.timestamp,
    this.isSynced = false,
  });

  Message copyWith({
    String? id,
    String? content,
    MessageRole? role,
    DateTime? timestamp,
    bool? isSynced,
  }) {
    return Message(
      id: id ?? this.id,
      content: content ?? this.content,
      role: role ?? this.role,
      timestamp: timestamp ?? this.timestamp,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  @override
  List<Object?> get props => [id, content, role, timestamp, isSynced];
}