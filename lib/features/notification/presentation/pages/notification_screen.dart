import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starnest/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:starnest/features/notification/presentation/controllers/notification_controller.dart';
import 'package:starnest/features/review/presentation/pages/main_review_screen_movies.dart';

const Color darkBackgroundColor = Color(0xFF0B0B0B);
const Color secondaryTextColor = Color(0xFF626365);
const Color primaryTextColor = Colors.white;
const Color dividerColor = Color(0xFF191919);

class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key});

  final DashboardController dashboardController =
      Get.find<DashboardController>();
  final NotificationController notificationController = Get.put(
    NotificationController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            dashboardController.selectedBottomNavIndex.value = 0;
          },
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: primaryTextColor,
            fontSize: 14,
            fontFamily: 'General Sans Variable',
            fontWeight: FontWeight.w600,
            height: 0.72,
          ),
        ),
        backgroundColor: darkBackgroundColor,
        centerTitle: true,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: dividerColor, height: 1.0),
        ),
      ),
      body: Obx(() {
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          itemCount: notificationController.notifications.length,
          itemBuilder: (context, index) {
            final n = notificationController.notifications[index];
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: dividerColor, width: 1),
                ),
              ),
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MainReviewScreenMovies(movieId: n.id),
                    ),
                  );
                },
                leading: Container(
                  width: 56,
                  height: 56,
                  decoration: ShapeDecoration(
                    color: Colors.grey,
                    image: DecorationImage(
                      image: NetworkImage(n.imageUrl),
                      fit: BoxFit.cover,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                title: Text(
                  n.title,
                  style: const TextStyle(
                    color: primaryTextColor,
                    fontSize: 16,
                    fontFamily: 'General Sans Variable',
                    fontWeight: FontWeight.w600,
                    height: 0.72,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6),
                    Text(
                      n.subtitle,
                      style: const TextStyle(
                        color: secondaryTextColor,
                        fontSize: 10,
                        fontFamily: 'General Sans Variable',
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.50,
                        height: 0.72,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      n.status,
                      style: const TextStyle(
                        color: secondaryTextColor,
                        fontSize: 14,
                        fontFamily: 'General Sans Variable',
                        fontWeight: FontWeight.w500,
                        height: 0.72,
                      ),
                    ),
                  ],
                ),
                contentPadding: EdgeInsets.zero,
              ),
            );
          },
        );
      }),
    );
  }
}
