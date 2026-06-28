import '../models/notification_model.dart';

abstract class NotificationLocalDataSource {
  List<NotificationModel> getNotifications();
  Future<void> cacheNotifications(List<NotificationModel> notifications);
  Future<void> markAsRead(String notificationId);
  Future<void> deleteNotification(String notificationId);
}

class NotificationLocalDataSourceImpl implements NotificationLocalDataSource {
  @override
  List<NotificationModel> getNotifications() {
    // This would typically read from local storage or API
    // For now, returning mock data
    return [
      NotificationModel(
        id: 'Kingdom',
        title: 'Kingdom',
        subtitle: 'Vijay Devarakonda, Bhagyashri Bhorse',
        status: 'Releasing on 31 July, 2025',
        imageUrl: 'https://placehold.co/56x56/E05473/FFFFFF?text=K',
      ),
      NotificationModel(
        id: 'Mirai',
        title: 'Mirai',
        subtitle: 'Teja Sajja, Manchu Manoj',
        status: 'Releasing Soon',
        imageUrl: 'https://placehold.co/56x56/54B6E0/FFFFFF?text=M',
      ),
      NotificationModel(
        id: 'Peddi',
        title: 'Peddi',
        subtitle: 'Ram Charan',
        status: 'First Look releasing today',
        imageUrl: 'https://placehold.co/56x56/E0B654/FFFFFF?text=P',
      ),
      NotificationModel(
        id: 'GTA VI',
        title: 'GTA VI',
        subtitle: 'Rockstar Games',
        status: 'Watch new Trailer',
        imageUrl: 'https://placehold.co/56x56/8B54E0/FFFFFF?text=GTA',
      ),
    ];
  }

  @override
  Future<void> cacheNotifications(List<NotificationModel> notifications) async {
    // This would typically save to local storage
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    // This would typically update local storage
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    // This would typically remove from local storage
  }
}
