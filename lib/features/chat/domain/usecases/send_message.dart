import '../entities/chat_message.dart';
import '../repositories/chat_repository.dart';

class SendMessage {
  final ChatRepository repository;

  SendMessage(this.repository);

  Future<void> call(ChatMessage message) {
    return repository.sendMessage(message);
  }
}
