class Notification {
  final String id;
  final String title;
  final String subtitle;
  final String status;
  final String imageUrl;

  Notification({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.imageUrl,
  });

  Notification copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? status,
    String? imageUrl,
  }) {
    return Notification(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      status: status ?? this.status,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
