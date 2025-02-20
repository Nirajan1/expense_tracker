import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final int id;
  final String name;
  final String slug;
  final bool isDefault;
  const CategoryEntity({
    required this.id,
    required this.name,
    required this.slug,
    required this.isDefault,
  });
  @override
  List<Object?> get props => [
        id,
        name,
        slug,
        isDefault,
      ];
}
