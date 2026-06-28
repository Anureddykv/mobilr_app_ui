import '../models/navigation_state_model.dart';

abstract class NavigationLocalDataSource {
  NavigationStateModel getNavigationState();
  Future<void> cacheNavigationState(NavigationStateModel state);
}

class NavigationLocalDataSourceImpl implements NavigationLocalDataSource {
  int _cachedIndex = 0;

  @override
  NavigationStateModel getNavigationState() {
    return NavigationStateModel(selectedIndex: _cachedIndex);
  }

  @override
  Future<void> cacheNavigationState(NavigationStateModel state) async {
    _cachedIndex = state.selectedIndex;
    // This would typically save to SharedPreferences or similar
  }
}
