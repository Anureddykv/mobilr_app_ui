import 'package:get/get.dart';
import 'package:starnest/features/dashboard/data/data_sources/navigation_local_data_source.dart';
import 'package:starnest/features/dashboard/domain/usecases/get_navigation_state.dart';
import 'package:starnest/features/dashboard/domain/usecases/update_navigation_state.dart';
import 'package:starnest/features/dashboard/data/repositories_impl/navigation_repository_impl.dart';

class DashboardController extends GetxController {
  final RxInt selectedBottomNavIndex = 0.obs;
  late final GetNavigationState getNavigationStateUseCase;
  late final UpdateNavigationState updateNavigationStateUseCase;

  @override
  void onInit() {
    super.onInit();

    // Initialize dependencies
    final localDataSource = NavigationLocalDataSourceImpl();
    final repository = NavigationRepositoryImpl(
      localDataSource: localDataSource,
    );
    getNavigationStateUseCase = GetNavigationState(repository);
    updateNavigationStateUseCase = UpdateNavigationState(repository);

    _loadNavigationState();
  }

  Future<void> _loadNavigationState() async {
    try {
      final state = getNavigationStateUseCase();
      selectedBottomNavIndex.value = state.selectedIndex;
    } catch (e) {
      // Handle error - keep default index of 0
    }
  }

  void changeTabIndex(int index) {
    selectedBottomNavIndex.value = index;
    updateNavigationStateUseCase(index);
  }
}
