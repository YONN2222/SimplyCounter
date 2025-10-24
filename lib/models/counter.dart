import 'dart:convert';

class CounterItem {
  final String id;
  String name;
  int value;
  final DateTime createdAt;

  CounterItem({
    required this.id,
    required this.name,
    this.value = 0,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  CounterItem copyWith({String? name, int? value}) {
    return CounterItem(
      id: id,
      name: name ?? this.name,
      value: value ?? this.value,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'value': value,
    'createdAt': createdAt.toIso8601String(),
  };

  factory CounterItem.fromJson(Map<String, dynamic> j) {
    return CounterItem(
      id: j['id'] as String,
      name: j['name'] as String,
      value: (j['value'] as num).toInt(),
      createdAt: DateTime.parse(j['createdAt'] as String),
    );
  }

  static List<CounterItem> listFromJson(String jsonStr) {
    final arr = json.decode(jsonStr) as List<dynamic>;
    return arr
        .map((e) => CounterItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static String listToJson(List<CounterItem> items) {
    return json.encode(items.map((e) => e.toJson()).toList());
  }
}
