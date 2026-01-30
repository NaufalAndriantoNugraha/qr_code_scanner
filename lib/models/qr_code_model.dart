class QrCodeModel {
  final int? id;
  final String name;
  final String link;

  const QrCodeModel({
    this.id,
    required this.name,
    required this.link,
  });

  factory QrCodeModel.fromJson(Map<String, dynamic> json) {
    return QrCodeModel(
      id: json['id'],
      name: json['name'],
      link: json['link'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'link': link,
    };
  }
}
