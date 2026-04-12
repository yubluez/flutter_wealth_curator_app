class Transaction {
  String? id;
  double amount;
  String type;
  String catId;
  String userId;
  String? imageUrl;
  DateTime? createdAt;

  Transaction({
    this.id,
    required this.amount,
    required this.type,
    required this.catId,
    required this.userId,
    this.imageUrl,
    this.createdAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      amount: (json['amount'] as num).toDouble(),
      type: json['type'],
      catId: json['cat_id'],
      userId: json['user_id'],
      imageUrl: json['image_url'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'type': type,
      'cat_id': catId,
      'user_id': userId,
      'image_url': imageUrl,
    };
  }
}