import 'package:expense_tracker/features/category/domain_layer/entity/category_entity.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class CategoryModel {
  @Id()
  int id = 0; // ObjectBox will auto-assign IDs
  final String name;
  @Unique()
  final String slug;
  final bool isDefault;

  CategoryModel({
    this.id = 0, // Keep default as 0, ObjectBox will assign a unique ID
    required this.name,
    required this.slug,
    this.isDefault = false,
  });

  factory CategoryModel.fromEntity(CategoryEntity categoryEntity) {
    return CategoryModel(
      id: categoryEntity.id,
      name: categoryEntity.name,
      slug: categoryEntity.slug,
      isDefault: categoryEntity.isDefault,
    );
  }

  CategoryEntity toEntity() {
    return CategoryEntity(
      id: id,
      name: name,
      slug: slug,
      isDefault: isDefault,
    );
  }
}
