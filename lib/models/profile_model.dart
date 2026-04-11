// Profile model class
class Profile {
  // ตัวแปรที่แมปกับชื่อคอลัมน์ใน table
  String? id;
  String? name;
  String? avatarUrl;

  // construct
  Profile({
    this.id,
    this.name,
    this.avatarUrl,
  });

  // แปลงข้อมูลจาก Server/Cloud ซึ่งเป็นข้อมูล JSON มาเป็นข้อมูลที่จะใช้ในแอป (fromJson)
  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        id: json['id'],
        name: json['name'],
        avatarUrl: json['avatar_url'],
      );
      
  // แปลงข้อมูลในแอปเป็น JSON เพื่อส่งไปยัง Server/Cloud (toJson)
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'avatar_url': avatarUrl,
      };
}