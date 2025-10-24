import 'package:flutter/material.dart';
import 'package:mobilr_app_ui/review/MainReviewScreenMovies.dart';

// ✅ Your NotificationScreen (same code you shared)
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

  final List<NotificationItem> _notifications =  [
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
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: darkBackgroundColor,
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          final n = _notifications[index];
          return GestureDetector(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MainReviewScreenMovies( movieId: n.id,),
                ),
              );
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: ShapeDecoration(
                    image: DecorationImage(
                      image: NetworkImage(n.imageUrl),
                      fit: BoxFit.cover,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        n.title,
                        style: const TextStyle(
                          color: primaryTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        n.subtitle,
                        style: const TextStyle(
                          color: secondaryTextColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        n.status,
                        style: const TextStyle(
                          color: secondaryTextColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (_, __) => const Divider(
          color: dividerColor,
          height: 24,
          thickness: 1,
        ),
      ),
    );
  }
}
