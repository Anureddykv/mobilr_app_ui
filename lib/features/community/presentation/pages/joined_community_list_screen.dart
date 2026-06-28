import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starnest/features/chat/presentation/pages/features_screen_community.dart';
import 'package:starnest/features/community/domain/entities/community.dart';
import 'package:starnest/features/community/presentation/controllers/community_controller.dart';
import 'package:starnest/features/community/presentation/pages/community_info_screen.dart';
import 'package:starnest/features/dashboard/presentation/controllers/dashboard_controller.dart';

class JoinedCommunityListScreen extends StatelessWidget {
  const JoinedCommunityListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CommunityController communityController = Get.put(
      CommunityController(),
    );
    final DashboardController dashboardController =
        Get.find<DashboardController>();

    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0B),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            dashboardController.selectedBottomNavIndex.value = 0;
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
          child: Divider(color: Color(0xFF191919), height: 1, thickness: 1),
        ),
      ),
      body: Obx(() {
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          itemCount: communityController.communities.length,
          itemBuilder: (context, index) {
            return CommunityListItem(
              community: communityController.communities[index],
            );
          },
        );
      }),
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
        Get.to(
          () => FeaturesScreenCommunity(
            communityId: community.id,
            communityName: community.name,
            communityImageUrl: community.imageUrl,
          ),
        );
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
                Get.to(
                  () => FeaturesScreenCommunityInfo(
                    communityName: community.name,
                    communityImageUrl: community.imageUrl,
                    memberCount: community.memberCount,
                  ),
                );
              },
              child: SizedBox(
                width: 56,
                height: 56,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    community.imageUrl,
                    fit: BoxFit.cover,
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
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[850],
                        child: const Icon(
                          Icons.group_work,
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
                      height: 0.72,
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
                    height: 0.72,
                  ),
                ),
                const SizedBox(height: 10),
                if (community.unreadCount > 0)
                  Container(
                    constraints: const BoxConstraints(minWidth: 15),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 4,
                    ),
                    decoration: ShapeDecoration(
                      color: const Color(0xFF9DD870),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      community.unreadCount.toString(),
                      style: const TextStyle(
                        color: Color(0xFF0B0B0B),
                        fontSize: 10,
                        fontFamily: 'General Sans Variable',
                        fontWeight: FontWeight.w600,
                        height: 0.72,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                else
                  const SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
