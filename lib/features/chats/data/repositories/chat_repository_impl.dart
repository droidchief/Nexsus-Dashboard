import 'package:uuid/uuid.dart';
import '../../../../core/storage/local_storage.dart';
import '../../../../core/storage/sync_manager.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../models/message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final LocalStorage _storage;
  final SyncManager _syncManager;
  final _uuid = const Uuid();

  ChatRepositoryImpl(this._storage, this._syncManager);

  @override
  Future<List<Message>> getMessages() async {
    final messagesData = _storage.getAllMessages();
    return messagesData.map((json) => MessageModel.fromJson(json)).toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  @override
  Future<void> saveMessage(Message message) async {
    final model = MessageModel.fromEntity(message);
    await _storage.saveMessage(message.id, model.toJson());
    
    // Queue for sync
    await _syncManager.queueAction('save_message', model.toJson());
  }

  @override
  Future<Message> sendMessage(String content) async {
    // Save user message
    final userMessage = Message(
      id: _uuid.v4(),
      content: content,
      role: MessageRole.user,
      timestamp: DateTime.now(),
    );
    await saveMessage(userMessage);

    // Simulate AI response with delay
    await Future.delayed(const Duration(seconds: 1));
    
    final aiResponse = _generateMockResponse(content);
    final assistantMessage = Message(
      id: _uuid.v4(),
      content: aiResponse,
      role: MessageRole.assistant,
      timestamp: DateTime.now(),
    );
    await saveMessage(assistantMessage);

    return assistantMessage;
  }

  @override
  Future<void> clearHistory() async {
    await _storage.messagesBox.clear();
  }

  String _generateMockResponse(String userInput) {
    final responses = [
      "That's an interesting question! Based on your query about '$userInput', here's what I can help you with...",
      "I understand you're asking about '$userInput'. Let me provide some insights on that.",
      "Great question! Regarding '$userInput', I'd say that it's important to consider multiple perspectives.",
      "Thanks for reaching out! About '$userInput' - this is a topic that requires careful consideration.",
      "I appreciate your inquiry about '$userInput'. Here's my take on it...",
    ];
    
    return responses[DateTime.now().millisecond % responses.length];
  }
}