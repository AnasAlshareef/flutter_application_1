class UserModel {
  int? id;
  String username;
  String passwordHash;
  String? email;
  double balance;
  String? createdAt;

  UserModel({
    this.id,
    required this.username,
    required this.passwordHash,
    this.email,
    this.balance = 0.0,
    this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      username: map['username'],
      passwordHash: map['password_hash'],
      email: map['email'],
      balance: (map['balance'] ?? 0).toDouble(),
      createdAt: map['created_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'username': username,
      'password_hash': passwordHash,
      'email': email,
      'balance': balance,
      'created_at': createdAt,
    };
  }
}
