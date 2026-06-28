import '../../domain/entities/notification.dart';
import '../../domain/repositories/notification_repository.dart';
import '../data_sources/notification_local_data_source.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationLocalDataSource localDataSource;

  NotificationRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Notification>> getNotifications() async {
    final notificationModels = localDataSource.getNotifications();
    return notificationModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    await localDataSource.markAsRead(notificationId);
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    await localDataSource.deleteNotification(notificationId);
  }
}
