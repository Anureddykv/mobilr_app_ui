import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../data_sources/chat_local_data_source.dart';
import '../models/chat_message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatLocalDataSource localDataSource;

  ChatRepositoryImpl({required this.localDataSource});

  @override
  Future<List<ChatMessage>> getMessages(String communityId) async {
    final messageModels = localDataSource.getMessages(communityId);
    return messageModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> sendMessage(ChatMessage message) async {
    final messageModel = ChatMessageModel.fromEntity(message);
    await localDataSource.addMessage(message.userId, messageModel);
  }

  @override
  Future<void> deleteMessage(String messageId) async {
    // This would typically remove from local storage
    // For now, this is a placeholder
  }
}
