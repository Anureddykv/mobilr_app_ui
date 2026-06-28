import '../repositories/navigation_repository.dart';

class UpdateNavigationState {
  final NavigationRepository repository;

  UpdateNavigationState(this.repository);

  Future<void> call(int index) {
    return repository.updateNavigationState(index);
  }
}
