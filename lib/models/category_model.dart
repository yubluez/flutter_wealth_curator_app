class Category {
  String? id;
  String? name;
  String? color;
  String? type;

  Category({
    this.id,
    this.name,
    this.color,
    this.type,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      color: json['color'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': color,
      'type': type
    };
  }
}
