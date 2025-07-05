class CategoryModel {
  int? id;
  String name;
  String type; // 'income' or 'expense'

  CategoryModel({
    this.id,
    required this.name,
    required this.type,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'],
      name: map['name'],
      type: map['type'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'type': type,
    };
  }
}
