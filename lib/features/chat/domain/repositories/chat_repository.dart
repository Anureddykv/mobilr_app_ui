import '../entities/chat_message.dart';

abstract class ChatRepository {
  Future<List<ChatMessage>> getMessages(String communityId);
  Future<void> sendMessage(ChatMessage message);
  Future<void> deleteMessage(String messageId);
}
