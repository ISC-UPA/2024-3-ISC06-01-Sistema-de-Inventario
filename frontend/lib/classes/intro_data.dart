class IntroData {
  final String title;
  final String lottie;
  final String description;
  final bool isLast;

  IntroData({
    required this.title,
    required this.lottie,
    required this.description,
    this.isLast = false,
  });

  factory IntroData.fromJson(Map<String, dynamic> json) {
    return IntroData(
      title: json['title'],
      lottie: json['image'],
      description: json['description'],
      isLast: json['isLast'] ?? false,
    );
  }
}
