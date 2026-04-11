// Transaction model class
class Transaction {
  // ตัวแปรที่แมปกับชื่อคอลัมน์ใน table
  String? id;
  double? amount;
  String? type;
  String? catId;
  String? userId;
  String? imageUrl;

  // construct
  Transaction({
    this.id,
    this.amount,
    this.type,
    this.catId,
    this.userId,
    this.imageUrl,
  });

  // แปลงข้อมูลจาก Server/Cloud ซึ่งเป็นข้อมูล JSON มาเป็นข้อมูลที่จะใช้ในแอป (fromJson)
  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        id: json['id'],
        amount: json['amount'],
        type: json['type'],
        catId: json['cat_id'],
        userId: json['user_id'],
        imageUrl: json['image_url'],
      );

  // แปลงข้อมูลในแอปเป็น JSON เพื่อส่งไปยัง Server/Cloud (toJson)
  Map<String, dynamic> toJson() => {
        'id': id,
        'amount': amount,
        'type': type,
        'cat_id': catId,
        'user_id': userId,
        'image_url': imageUrl,
      };
}
