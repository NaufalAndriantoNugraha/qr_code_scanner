class QrCodeModel {
  final String name;
  final String link;

  const QrCodeModel({
    required this.name,
    required this.link,
  });

  factory QrCodeModel.fromJson(Map<String, dynamic> json) {
    return QrCodeModel(
      name: json['name'],
      link: json['link'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'link': link,
    };
  }
}
