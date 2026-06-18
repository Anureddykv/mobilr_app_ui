/// String utility extensions for the StarNest app.
extension StringExtension on String {
  /// Capitalises the first character: 'hello' → 'Hello'
  String get capitalizeFirst =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';

  /// Capitalises the first letter of every word: 'hello world' → 'Hello World'
  String get titleCase => split(' ').map((w) => w.capitalizeFirst).join(' ');

  /// Returns true if this is a valid email address.
  bool get isValidEmail {
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return regex.hasMatch(this);
  }

  /// Returns true if the string has at least [length] characters.
  bool hasMinLength(int length) => this.length >= length;

  /// Truncates to [maxLength] and appends '...' if longer.
  String truncate(int maxLength) =>
      length <= maxLength ? this : '${substring(0, maxLength)}...';

  /// Removes all whitespace.
  String get removeSpaces => replaceAll(' ', '');

  /// Returns null if the string is empty, otherwise returns itself.
  String? get nullIfEmpty => isEmpty ? null : this;
}

/// Nullable string extensions.
extension NullableStringExtension on String? {
  /// Returns true if null or empty.
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  /// Returns the value or a fallback string.
  String orDefault([String fallback = '']) => this ?? fallback;
}
