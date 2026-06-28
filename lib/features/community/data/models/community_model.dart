import '../../domain/entities/community.dart';

class CommunityModel extends Community {
  CommunityModel({
    required super.id,
    required super.imageUrl,
    required super.name,
    required super.lastMessage,
    required super.time,
    required super.unreadCount,
    required super.memberCount,
  });

  factory CommunityModel.fromJson(Map<String, dynamic> json) {
    return CommunityModel(
      id: json['id'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      name: json['name'] ?? '',
      lastMessage: json['lastMessage'] ?? '',
      time: json['time'] ?? '',
      unreadCount: json['unreadCount'] ?? 0,
      memberCount: json['memberCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'name': name,
      'lastMessage': lastMessage,
      'time': time,
      'unreadCount': unreadCount,
      'memberCount': memberCount,
    };
  }

  Community toEntity() {
    return Community(
      id: id,
      imageUrl: imageUrl,
      name: name,
      lastMessage: lastMessage,
      time: time,
      unreadCount: unreadCount,
      memberCount: memberCount,
    );
  }

  factory CommunityModel.fromEntity(Community entity) {
    return CommunityModel(
      id: entity.id,
      imageUrl: entity.imageUrl,
      name: entity.name,
      lastMessage: entity.lastMessage,
      time: entity.time,
      unreadCount: entity.unreadCount,
      memberCount: entity.memberCount,
    );
  }
}
