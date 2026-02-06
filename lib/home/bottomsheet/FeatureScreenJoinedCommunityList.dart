import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobilr_app_ui/chat/features_screen_community.dart';
import 'package:mobilr_app_ui/home/bottomsheet/features_screen_community_info.dart';
import 'package:mobilr_app_ui/home/controllers/home_controller.dart';

// Your existing Community and NavItem models are unchanged.
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
}

class NavItem {
  final IconData icon;
  final bool isSelected;

  const NavItem({required this.icon, this.isSelected = false});
}

class FeatureScreenJoinedCommunityList extends StatelessWidget {
  static final List<Community> _communities = [
    const Community(
      id: 'kingdom123',
      imageUrl: 'https://placehold.co/56x56/AABBCC/FFFFFF?text=K',
      name: 'Kingdom',
      lastMessage:
      'Pavan: Satya Dev acted very well. The mallu guy’s acting was also good.',
      time: '8:15',
      unreadCount: 12,
      memberCount: 2500,
    ),
    const Community(
      id: 'rebel_fans_456',
      imageUrl: 'https://placehold.co/56x56/CCBBAA/FFFFFF?text=R',
      name: 'Rebel Star Fans',
      lastMessage: 'Admin: @charan Please be good',
      time: '22:10',
      unreadCount: 4,
      memberCount: 1200,
    ),
    const Community(
      id: 'gta_vi_789',
      imageUrl: 'https://placehold.co/56x56/AACCBB/FFFFFF?text=M',
      name: 'Manifesting GTA VI',
      lastMessage:
      'Rahul: I think my grand son will also be waiting for the release.',
      time: '11:11',
      unreadCount: 911,
      memberCount: 15000,
    ),
    const Community(
      id: 'super_star_101',
      imageUrl: 'https://placehold.co/56x56/BBAACC/FFFFFF?text=S',
      name: 'Super Star Rajini',
      lastMessage: 'Vijay: 📷 Photo',
      time: '7:56',
      unreadCount: 170,
      memberCount: 8900,
    ),
  ];

  const FeatureScreenJoinedCommunityList({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();

    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0B),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            homeController.selectedBottomNavIndex.value = 0;
          },
        ),
        title: const Text(
          'Communities',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontFamily: 'General Sans Variable',
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF0B0B0B),
        centerTitle: true,
        elevation: 0,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(
            color: Color(0xFF191919),
            height: 1,
            thickness: 1,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        itemCount: _communities.length,
        itemBuilder: (context, index) {
          return CommunityListItem(community: _communities[index]);
        },
      ),
    );
  }
}

class CommunityListItem extends StatelessWidget {
  final Community community;
  const CommunityListItem({super.key, required this.community});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => FeaturesScreenCommunity(
          communityId: community.id,
          communityName: community.name,
          communityImageUrl: community.imageUrl,
        ));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFF191919), width: 1),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Community Image with onTap for info screen
            GestureDetector(
              onTap: () {
                Get.to(() => FeaturesScreenCommunityInfo(
                  communityName: community.name,
                  communityImageUrl: community.imageUrl,
                  memberCount: community.memberCount,
                ));
              },
              // ✅ IMPROVED: Added loading and error handling to the image.
              child: SizedBox(
                width: 56,
                height: 56,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    community.imageUrl,
                    fit: BoxFit.cover,
                    // Show a placeholder while the image is loading
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: Colors.grey[850],
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.grey[600],
                          ),
                        ),
                      );
                    },
                    // Show a fallback icon if the image fails to load
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[850],
                        child: const Icon(
                          Icons.group_work, // Fallback icon
                          color: Colors.white24,
                          size: 30,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Name and Message
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    community.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'General Sans Variable',
                      fontWeight: FontWeight.w600,
                      height: 0.72
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    community.lastMessage,
                    style: const TextStyle(
                      color: Color(0xFF626365),
                      fontSize: 14,
                      fontFamily: 'General Sans Variable',
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // Time and Unread Count
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  community.time,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontFamily: 'General Sans Variable',
                    fontWeight: FontWeight.w400,
                      height: 0.72
                  ),
                ),
                const SizedBox(height: 10),
                if (community.unreadCount > 0)
                  Container(
                    constraints: const BoxConstraints(minWidth: 15),
                    padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    decoration: ShapeDecoration(
                      color: const Color(0xFF9DD870),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(
                      community.unreadCount.toString(),
                      style: const TextStyle(
                        color: Color(0xFF0B0B0B),
                        fontSize: 10,
                        fontFamily: 'General Sans Variable',
                        fontWeight: FontWeight.w600,
                          height: 0.72
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                else
                // Add a placeholder to maintain alignment
                  const SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
