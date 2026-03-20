class ChatMessage {
  final String id;
  final String text;
  final String userId;
  final String userName;
  final String avatarUrl;
  final DateTime timestamp;
  final bool isMe;

  ChatMessage({
    required this.id,
    required this.text,
    required this.userId,
    required this.userName,
    required this.avatarUrl,
    required this.timestamp,
    required this.isMe,
  });
}