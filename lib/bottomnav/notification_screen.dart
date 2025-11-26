import 'package:flutter/material.dart';
import 'package:mobilr_app_ui/review/MainReviewScreenMovies.dart';

class NotificationItem {
  final String id;
  final String title;
  final String subtitle;
  final String status;
  final String imageUrl;

  NotificationItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.imageUrl,
  });
}

const Color darkBackgroundColor = Color(0xFF0B0B0B);
const Color secondaryTextColor = Color(0xFF626365);
const Color primaryTextColor = Colors.white;
const Color dividerColor = Color(0xFF191919);

class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key});

  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: 'Kingdom',
      title: 'Kingdom',
      subtitle: 'Vijay Devarakonda, Bhagyashri Bhorse',
      status: 'Releasing on 31 July, 2025',
      imageUrl: 'https://placehold.co/56x56/E05473/FFFFFF?text=K',
    ),
    NotificationItem(
      id: 'Mirai',
      title: 'Mirai',
      subtitle: 'Teja Sajja, Manchu Manoj',
      status: 'Releasing Soon',
      imageUrl: 'https://placehold.co/56x56/54B6E0/FFFFFF?text=M',
    ),
    NotificationItem(
      id: 'Peddi',
      title: 'Peddi',
      subtitle: 'Ram Charan',
      status: 'First Look releasing today',
      imageUrl: 'https://placehold.co/56x56/E0B654/FFFFFF?text=P',
    ),
    NotificationItem(
      id: 'GTA VI',
      title: 'GTA VI',
      subtitle: 'Rockstar Games',
      status: 'Watch new Trailer',
      imageUrl: 'https://placehold.co/56x56/8B54E0/FFFFFF?text=GTA',
    ),
    NotificationItem(
      id: 'GTA VI',
      title: 'GTA VI',
      subtitle: 'Rockstar Games',
      status: 'Watch new Trailer',
      imageUrl: 'https://placehold.co/56x56/8B54E0/FFFFFF?text=GTA',
    ),
    NotificationItem(
      id: 'GTA VI',
      title: 'GTA VI',
      subtitle: 'Rockstar Games',
      status: 'Watch new Trailer',
      imageUrl: 'https://placehold.co/56x56/8B54E0/FFFFFF?text=GTA',
    ),
    NotificationItem(
      id: 'GTA VI',
      title: 'GTA VI',
      subtitle: 'Rockstar Games',
      status: 'Watch new Trailer',
      imageUrl: 'https://placehold.co/56x56/8B54E0/FFFFFF?text=GTA',
    ),
    NotificationItem(
      id: 'GTA VI',
      title: 'GTA VI',
      subtitle: 'Rockstar Games',
      status: 'Watch new Trailer',
      imageUrl: 'https://placehold.co/56x56/8B54E0/FFFFFF?text=GTA',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: primaryTextColor,
            fontSize: 14,
            fontFamily: 'General Sans Variable',
            fontWeight: FontWeight.w600,
              height: 0.72
          ),
        ),
        backgroundColor: darkBackgroundColor,
        centerTitle: true,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: dividerColor,
            height: 1.0,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          final n = _notifications[index];
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
                    builder: (context) => MainReviewScreenMovies(movieId: n.id),
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
                  height: 0.72
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
                        height: 0.72
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
                        height: 0.72
                    ),
                  ),
                ],
              ),
              contentPadding: EdgeInsets.zero, // Let the outer container handle padding
            ),
          );
        },
      ),
    );
  }
}
