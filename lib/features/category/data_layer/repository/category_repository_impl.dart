import 'package:expense_tracker/features/category/data_layer/data_source/category_data_source.dart';
import 'package:expense_tracker/features/category/data_layer/model/category_model.dart';
import 'package:expense_tracker/features/category/domain_layer/entity/category_entity.dart';
import 'package:expense_tracker/features/category/domain_layer/repositories/category_repositories.dart';

class CategoryRepositoryImpl implements CategoryRepositories {
  final CategoryDataSource categoryDataSource;
  CategoryRepositoryImpl({required this.categoryDataSource});

  @override
  Future<void> addCategory({required CategoryEntity categoryEntity}) async {
    final slug = _generateSlug(categoryEntity.slug);
    final categoryModel = CategoryModel(name: categoryEntity.name, slug: slug);
    await categoryDataSource.addCategory(categoryModel: categoryModel);
  }

  @override
  Future<void> deleteCategory({required int id}) async {
    await categoryDataSource.deleteCategory(id: id);
  }

  @override
  Future<List<CategoryEntity>> getCategories() async {
    final categoryListModel = await categoryDataSource.getAllCategory();
    return categoryListModel.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> updateCategory({required CategoryEntity categoryEntity}) async {
    final categoryModel = CategoryModel.fromEntity(categoryEntity);
    return await categoryDataSource.updateCategory(categoryModel: categoryModel);
  }

  String _generateSlug(String name) {
    return name
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]'), '-') // Replace non-alphanumeric with `-`
        .replaceAll(RegExp(r'-+'), '-') // Remove multiple `-`
        .trim();
  }
}
