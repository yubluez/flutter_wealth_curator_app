// Category model class
class Category {
  // ตัวแปรที่แมปกับชื่อคอลัมน์ใน table
  String? id;
  String? name;
  String? type;
  String? user_id;

  // construct
  Category({
    this.id,
    this.name,
    this.type,
    this.user_id,
  });

  // แปลงข้อมูลจาก Server/Cloud ซึ่งเป็นข้อมูล JSON มาเป็นข้อมูลที่จะใช้ในแอป (fromJson)
  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json['id'],
        name: json['name'],
        type: json['type'],
        user_id: json['user_id'],
      );

  // แปลงข้อมูลในแอปเป็น JSON เพื่อส่งไปยัง Server/Cloud (toJson)
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type,
        'user_id': user_id,
      };
}

// Profile model class
class Profile {
  // ตัวแปรที่แมปกับชื่อคอลัมน์ใน table
  String? id;
  String? name;
  String? avatar_url;

  // construct
  Profile({
    this.id,
    this.name,
    this.avatar_url,
  });

  // แปลงข้อมูลจาก Server/Cloud ซึ่งเป็นข้อมูล JSON มาเป็นข้อมูลที่จะใช้ในแอป (fromJson)
  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        id: json['id'],
        name: json['name'],
        avatar_url: json['avatar_url'],
      );
      
  // แปลงข้อมูลในแอปเป็น JSON เพื่อส่งไปยัง Server/Cloud (toJson)
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'avatar_url': avatar_url,
      };
}

// Transaction model class
class Transaction {
  // ตัวแปรที่แมปกับชื่อคอลัมน์ใน table
  String? id;
  double? amount;
  String? type;
  String? cat_id;
  String? user_id;
  String? image_url;

  // construct
  Transaction({
    this.id,
    this.amount,
    this.type,
    this.cat_id,
    this.user_id,
    this.image_url,
  });

  // แปลงข้อมูลจาก Server/Cloud ซึ่งเป็นข้อมูล JSON มาเป็นข้อมูลที่จะใช้ในแอป (fromJson)
  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        id: json['id'],
        amount: json['amount'],
        type: json['type'],
        cat_id: json['cat_id'],
        user_id: json['user_id'],
        image_url: json['image_url'],
      );

  // แปลงข้อมูลในแอปเป็น JSON เพื่อส่งไปยัง Server/Cloud (toJson)
  Map<String, dynamic> toJson() => {
        'id': id,
        'amount': amount,
        'type': type,
        'cat_id': cat_id,
        'user_id': user_id,
        'image_url': image_url,
      };
}