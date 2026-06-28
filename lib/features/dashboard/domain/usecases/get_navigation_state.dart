import '../entities/navigation_state.dart';
import '../repositories/navigation_repository.dart';

class GetNavigationState {
  final NavigationRepository repository;

  GetNavigationState(this.repository);

  NavigationState call() {
    return repository.getNavigationState();
  }
}
