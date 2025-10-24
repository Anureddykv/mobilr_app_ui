class OnboardingModel {
  final String imageUrl;
  final String text;

  OnboardingModel({required this.imageUrl, required this.text});

  factory OnboardingModel.fromJson(Map<String, dynamic> json) {
    return OnboardingModel(
      imageUrl: json["imageUrl"] ?? "",
      text: json["text"] ?? "",
    );
  }
}
