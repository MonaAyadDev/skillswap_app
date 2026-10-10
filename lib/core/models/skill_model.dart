import 'package:equatable/equatable.dart';

class SkillModel extends Equatable {
  final String id;
  final String name;
  final String category;

  const SkillModel({
    required this.id,
    required this.name,
    this.category = '',
  });

  factory SkillModel.fromMap(Map<String, dynamic> map, String id) {
    return SkillModel(
      id: id,
      name: map['name'] ?? '',
      category: map['category'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {'name': name, 'category': category};

  @override
  List<Object?> get props => [id, name, category];
}