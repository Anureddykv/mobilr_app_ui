class Community {
  final String id;
  final String imageUrl;
  final String name;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final int memberCount;

  const Community({
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.unreadCount,
    required this.memberCount,
  });

  Community copyWith({
    String? id,
    String? imageUrl,
    String? name,
    String? lastMessage,
    String? time,
    int? unreadCount,
    int? memberCount,
  }) {
    return Community(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      name: name ?? this.name,
      lastMessage: lastMessage ?? this.lastMessage,
      time: time ?? this.time,
      unreadCount: unreadCount ?? this.unreadCount,
      memberCount: memberCount ?? this.memberCount,
    );
  }
}
