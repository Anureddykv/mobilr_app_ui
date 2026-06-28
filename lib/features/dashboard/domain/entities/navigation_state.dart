class NavigationState {
  final int selectedIndex;

  const NavigationState({
    required this.selectedIndex,
  });

  NavigationState copyWith({
    int? selectedIndex,
  }) {
    return NavigationState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }
}
