import '../entities/navigation_state.dart';

abstract class NavigationRepository {
  NavigationState getNavigationState();
  Future<void> updateNavigationState(int index);
}
