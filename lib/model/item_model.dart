class DigimonModel {
  final String name;
  final String img;
  final String level;
  bool isTapped = false;

  DigimonModel({
    required this.name,
    required this.img,
    required this.level,
    this.isTapped = false,
  });

  factory DigimonModel.fromJson(Map<String, dynamic> json) {
    final rawImg = json['img'] as String? ?? '';
    final secureImg = rawImg.startsWith('http://')
        ? rawImg.replaceFirst('http://', 'https://')
        : rawImg;

    return DigimonModel(
      name: json['name'] ?? '',
      img: secureImg,
      level: json['level'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'img': img, 'level': level};
  }

  @override
  String toString() {
    return 'DigimonModel(name: $name, img: $img, level: $level)';
  }
}
