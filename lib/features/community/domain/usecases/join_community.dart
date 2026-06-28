import '../repositories/community_repository.dart';

class JoinCommunity {
  final CommunityRepository repository;

  JoinCommunity(this.repository);

  Future<void> call(String communityId) {
    return repository.joinCommunity(communityId);
  }
}
