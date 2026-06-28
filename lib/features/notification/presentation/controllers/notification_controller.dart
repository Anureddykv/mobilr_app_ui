import 'package:get/get.dart';
import 'package:starnest/features/notification/domain/entities/notification.dart';
import 'package:starnest/features/notification/domain/usecases/get_notifications.dart';
import 'package:starnest/features/notification/domain/usecases/mark_notification_as_read.dart';
import 'package:starnest/features/notification/data/data_sources/notification_local_data_source.dart';
import 'package:starnest/features/notification/data/repositories_impl/notification_repository_impl.dart';

class NotificationController extends GetxController {
  final RxList<Notification> notifications = <Notification>[].obs;
  late final GetNotifications getNotificationsUseCase;
  late final MarkNotificationAsRead markNotificationAsReadUseCase;

  @override
  void onInit() {
    super.onInit();
    
    // Initialize dependencies
    final localDataSource = NotificationLocalDataSourceImpl();
    final repository = NotificationRepositoryImpl(localDataSource: localDataSource);
    getNotificationsUseCase = GetNotifications(repository);
    markNotificationAsReadUseCase = MarkNotificationAsRead(repository);

    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    try {
      final loadedNotifications = await getNotificationsUseCase();
      notifications.value = loadedNotifications;
    } catch (e) {
      // Handle error - notifications list will remain empty
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await markNotificationAsReadUseCase(notificationId);
      // Optionally refresh the notifications list
      await _loadNotifications();
    } catch (e) {
      // Handle error
    }
  }
}
