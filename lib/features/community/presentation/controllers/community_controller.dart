import 'package:get/get.dart';
import 'package:starnest/features/community/domain/entities/community.dart';
import 'package:starnest/features/community/domain/usecases/get_communities.dart';
import 'package:starnest/features/community/domain/usecases/join_community.dart';
import 'package:starnest/features/community/data/data_sources/community_local_data_source.dart';
import 'package:starnest/features/community/data/repositories_impl/community_repository_impl.dart';

class CommunityController extends GetxController {
  final RxList<Community> communities = <Community>[].obs;
  late final GetCommunities getCommunitiesUseCase;
  late final JoinCommunity joinCommunityUseCase;

  @override
  void onInit() {
    super.onInit();

    // Initialize dependencies
    final localDataSource = CommunityLocalDataSourceImpl();
    final repository = CommunityRepositoryImpl(
      localDataSource: localDataSource,
    );
    getCommunitiesUseCase = GetCommunities(repository);
    joinCommunityUseCase = JoinCommunity(repository);

    _loadCommunities();
  }

  Future<void> _loadCommunities() async {
    try {
      final loadedCommunities = await getCommunitiesUseCase();
      communities.value = loadedCommunities;
    } catch (e) {
      // Handle error - communities list will remain empty
    }
  }

  Future<void> joinCommunity(String communityId) async {
    try {
      await joinCommunityUseCase(communityId);
      // Optionally refresh the communities list after joining
      await _loadCommunities();
    } catch (e) {
      // Handle error
    }
  }
}
