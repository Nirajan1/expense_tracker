import 'package:expense_tracker/features/category/domain_layer/entity/category_entity.dart';

abstract class CategoryRepositories {
  Future<List<CategoryEntity>> getCategories();
  Future<void> addCategory({required CategoryEntity categoryEntity});
  Future<void> updateCategory({required CategoryEntity categoryEntity});
  Future<void> deleteCategory({required int id});
}
