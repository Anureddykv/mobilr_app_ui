import '../models/community_model.dart';

abstract class CommunityLocalDataSource {
  List<CommunityModel> getCommunities();
  Future<void> cacheCommunities(List<CommunityModel> communities);
}

class CommunityLocalDataSourceImpl implements CommunityLocalDataSource {
  @override
  List<CommunityModel> getCommunities() {
    // This would typically read from local storage
    // For now, returning default mock data
    return [
      CommunityModel(
        id: 'kingdom123',
        imageUrl: 'https://placehold.co/56x56/AABBCC/FFFFFF?text=K',
        name: 'Kingdom',
        lastMessage:
            'Pavan: Satya Dev acted very well. The mallu guy\'s acting was also good.',
        time: '8:15',
        unreadCount: 12,
        memberCount: 2500,
      ),
      CommunityModel(
        id: 'rebel_fans_456',
        imageUrl: 'https://placehold.co/56x56/CCBBAA/FFFFFF?text=R',
        name: 'Rebel Star Fans',
        lastMessage: 'Admin: @charan Please be good',
        time: '22:10',
        unreadCount: 4,
        memberCount: 1200,
      ),
      CommunityModel(
        id: 'gta_vi_789',
        imageUrl: 'https://placehold.co/56x56/AACCBB/FFFFFF?text=M',
        name: 'Manifesting GTA VI',
        lastMessage:
            'Rahul: I think my grand son will also be waiting for the release.',
        time: '11:11',
        unreadCount: 911,
        memberCount: 15000,
      ),
      CommunityModel(
        id: 'super_star_101',
        imageUrl: 'https://placehold.co/56x56/BBAACC/FFFFFF?text=S',
        name: 'Super Star Rajini',
        lastMessage: 'Vijay: 📷 Photo',
        time: '7:56',
        unreadCount: 170,
        memberCount: 8900,
      ),
    ];
  }

  @override
  Future<void> cacheCommunities(List<CommunityModel> communities) async {
    // This would typically save to local storage
  }
}
