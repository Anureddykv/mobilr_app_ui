import '../../domain/entities/chat_message.dart';

class ChatMessageModel extends ChatMessage {
  ChatMessageModel({
    required super.id,
    required super.type,
    super.text,
    super.filePath,
    required super.userId,
    required super.userName,
    required super.avatarUrl,
    required super.timestamp,
    required super.isMe,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] ?? '',
      type: MessageType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => MessageType.text,
      ),
      text: json['text'],
      filePath: json['filePath'],
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
      timestamp: DateTime.parse(
        json['timestamp'] ?? DateTime.now().toIso8601String(),
      ),
      isMe: json['isMe'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'text': text,
      'filePath': filePath,
      'userId': userId,
      'userName': userName,
      'avatarUrl': avatarUrl,
      'timestamp': timestamp.toIso8601String(),
      'isMe': isMe,
    };
  }

  ChatMessage toEntity() {
    return ChatMessage(
      id: id,
      type: type,
      text: text,
      filePath: filePath,
      userId: userId,
      userName: userName,
      avatarUrl: avatarUrl,
      timestamp: timestamp,
      isMe: isMe,
    );
  }

  factory ChatMessageModel.fromEntity(ChatMessage entity) {
    return ChatMessageModel(
      id: entity.id,
      type: entity.type,
      text: entity.text,
      filePath: entity.filePath,
      userId: entity.userId,
      userName: entity.userName,
      avatarUrl: entity.avatarUrl,
      timestamp: entity.timestamp,
      isMe: entity.isMe,
    );
  }
}
