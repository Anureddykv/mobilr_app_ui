import '../models/chat_message_model.dart';

abstract class ChatLocalDataSource {
  List<ChatMessageModel> getMessages(String communityId);
  Future<void> cacheMessages(String communityId, List<ChatMessageModel> messages);
  Future<void> addMessage(String communityId, ChatMessageModel message);
}

class ChatLocalDataSourceImpl implements ChatLocalDataSource {
  final Map<String, List<ChatMessageModel>> _cachedMessages = {};

  @override
  List<ChatMessageModel> getMessages(String communityId) {
    // This would typically read from local storage or database
    // For now, returning cached messages or empty list
    return _cachedMessages[communityId] ?? [];
  }

  @override
  Future<void> cacheMessages(String communityId, List<ChatMessageModel> messages) async {
    _cachedMessages[communityId] = messages;
    // This would typically save to local storage
  }

  @override
  Future<void> addMessage(String communityId, ChatMessageModel message) async {
    if (!_cachedMessages.containsKey(communityId)) {
      _cachedMessages[communityId] = [];
    }
    _cachedMessages[communityId]!.add(message);
    // This would typically save to local storage
  }
}
