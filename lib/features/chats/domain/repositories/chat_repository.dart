import '../entities/message.dart';

abstract class ChatRepository {
  Future<List<Message>> getMessages();
  Future<void> saveMessage(Message message);
  Future<Message> sendMessage(String content);
  Future<void> clearHistory();
}