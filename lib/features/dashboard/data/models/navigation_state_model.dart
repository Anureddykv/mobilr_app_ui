import '../../domain/entities/navigation_state.dart';

class NavigationStateModel extends NavigationState {
  NavigationStateModel({
    required super.selectedIndex,
  });

  factory NavigationStateModel.fromJson(Map<String, dynamic> json) {
    return NavigationStateModel(
      selectedIndex: json['selectedIndex'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'selectedIndex': selectedIndex,
    };
  }

  NavigationState toEntity() {
    return NavigationState(
      selectedIndex: selectedIndex,
    );
  }

  factory NavigationStateModel.fromEntity(NavigationState entity) {
    return NavigationStateModel(
      selectedIndex: entity.selectedIndex,
    );
  }
}
