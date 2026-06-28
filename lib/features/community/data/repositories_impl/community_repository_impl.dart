import '../../domain/entities/community.dart';
import '../../domain/repositories/community_repository.dart';
import '../data_sources/community_local_data_source.dart';

class CommunityRepositoryImpl implements CommunityRepository {
  final CommunityLocalDataSource localDataSource;

  CommunityRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Community>> getCommunities() async {
    final communityModels = localDataSource.getCommunities();
    return communityModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Community?> getCommunityById(String id) async {
    final communities = await getCommunities();
    try {
      return communities.firstWhere((community) => community.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> joinCommunity(String communityId) async {
    // This would typically make an API call to join the community
    // For now, this is a placeholder
  }
}
