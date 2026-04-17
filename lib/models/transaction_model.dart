class Transaction {
  String? id;
  double amount;
  String type;
  String catId;
  String? imageUrl;
  DateTime? createdAt;
  String? note;
  String? userId;

  Transaction({
    this.id,
    required this.amount,
    required this.type,
    required this.catId,
    this.imageUrl,
    this.createdAt,
    this.note,
    this.userId,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      amount: (json['amount'] as num).toDouble(),
      type: json['type'],
      catId: json['cat_id'],
      imageUrl: json['image_url'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      note: json['note'],
      userId: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'type': type,
      'cat_id': catId,
      'image_url': imageUrl,
      'created_at': createdAt?.toIso8601String(),
      'note': note,
      'user_id': userId
    };
  }
}