// Category model class
class Category {
  // ตัวแปรที่แมปกับชื่อคอลัมน์ใน table
  String? id;
  String? name;
  String? type;
  String? userId;

  // construct
  Category({
    this.id,
    this.name,
    this.type,
    this.userId,
  });

  // แปลงข้อมูลจาก Server/Cloud ซึ่งเป็นข้อมูล JSON มาเป็นข้อมูลที่จะใช้ในแอป (fromJson)
  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json['id'],
        name: json['name'],
        type: json['type'],
        userId: json['user_id'],
      );

  // แปลงข้อมูลในแอปเป็น JSON เพื่อส่งไปยัง Server/Cloud (toJson)
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type,
        'user_id': userId,
      };
}
