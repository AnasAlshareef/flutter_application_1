class TransactionModel {
  int? id;
  int userId;
  int categoryId;
  double amount;
  String type; // 'income' or 'expense'
  String date; // ISO8601 date string

  TransactionModel({
    this.id,
    required this.userId,
    required this.categoryId,
    required this.amount,
    required this.type,
    required this.date,
  });

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      userId: map['user_id'],
      categoryId: map['category_id'],
      amount: (map['amount'] as num).toDouble(),
      type: map['type'],
      date: map['date'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'category_id': categoryId,
      'amount': amount,
      'type': type,
      'date': date,
    };
  }
}
