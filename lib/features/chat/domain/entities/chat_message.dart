enum MessageType { text, image, audio, file }

class ChatMessage {
  final String id;
  final MessageType type;
  final String? text;
  final String? filePath;
  final String userId;
  final String userName;
  final String avatarUrl;
  final DateTime timestamp;
  final bool isMe;

  ChatMessage({
    required this.id,
    required this.type,
    this.text,
    this.filePath,
    required this.userId,
    required this.userName,
    required this.avatarUrl,
    required this.timestamp,
    required this.isMe,
  });

  ChatMessage copyWith({
    String? id,
    MessageType? type,
    String? text,
    String? filePath,
    String? userId,
    String? userName,
    String? avatarUrl,
    DateTime? timestamp,
    bool? isMe,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      type: type ?? this.type,
      text: text ?? this.text,
      filePath: filePath ?? this.filePath,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      timestamp: timestamp ?? this.timestamp,
      isMe: isMe ?? this.isMe,
    );
  }
}
