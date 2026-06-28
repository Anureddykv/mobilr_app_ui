import '../entities/community.dart';

abstract class CommunityRepository {
  Future<List<Community>> getCommunities();
  Future<Community?> getCommunityById(String id);
  Future<void> joinCommunity(String communityId);
}
