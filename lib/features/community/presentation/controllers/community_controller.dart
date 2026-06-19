import 'package:get/get.dart';

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

class CommunityController extends GetxController {
  final communities = <Community>[
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
  ].obs;
}
