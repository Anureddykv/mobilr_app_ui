import '../../domain/entities/navigation_state.dart';
import '../../domain/repositories/navigation_repository.dart';
import '../data_sources/navigation_local_data_source.dart';
import '../models/navigation_state_model.dart';

class NavigationRepositoryImpl implements NavigationRepository {
  final NavigationLocalDataSource localDataSource;

  NavigationRepositoryImpl({required this.localDataSource});

  @override
  NavigationState getNavigationState() {
    final stateModel = localDataSource.getNavigationState();
    return stateModel.toEntity();
  }

  @override
  Future<void> updateNavigationState(int index) async {
    final stateModel = NavigationStateModel(selectedIndex: index);
    await localDataSource.cacheNavigationState(stateModel);
  }
}
