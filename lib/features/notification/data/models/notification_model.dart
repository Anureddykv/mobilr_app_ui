import '../../domain/entities/notification.dart';

class NotificationModel extends Notification {
  NotificationModel({
    required super.id,
    required super.title,
    required super.subtitle,
    required super.status,
    required super.imageUrl,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      status: json['status'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'status': status,
      'imageUrl': imageUrl,
    };
  }

  Notification toEntity() {
    return Notification(
      id: id,
      title: title,
      subtitle: subtitle,
      status: status,
      imageUrl: imageUrl,
    );
  }

  factory NotificationModel.fromEntity(Notification entity) {
    return NotificationModel(
      id: entity.id,
      title: entity.title,
      subtitle: entity.subtitle,
      status: entity.status,
      imageUrl: entity.imageUrl,
    );
  }
}
