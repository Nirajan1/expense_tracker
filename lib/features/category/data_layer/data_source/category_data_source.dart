import 'package:expense_tracker/features/category/data_layer/model/category_model.dart';
import 'package:expense_tracker/objectbox.g.dart';

abstract class CategoryDataSource {
  Future<void> addCategory({required CategoryModel categoryModel});
  Future<void> updateCategory({required CategoryModel categoryModel});
  Future<void> deleteCategory({required int id});
  Future<List<CategoryModel>> getAllCategory();
}

class CategoryDataSourceImpl implements CategoryDataSource {
  final Store store;
  late final Box<CategoryModel> categoryBox;
  CategoryDataSourceImpl({required this.store}) {
    categoryBox = store.box<CategoryModel>();
    defaultInitialization();
  }

  @override
  Future<void> addCategory({required CategoryModel categoryModel}) async {
    try {
      // Ensure slug is unique
      final existingCategory = categoryBox.query(CategoryModel_.slug.equals(categoryModel.slug)).build().findFirst();
      if (existingCategory != null) {
        throw Exception('Category with slug ${categoryModel.slug} already exists');
      }
      categoryBox.put(categoryModel);
    } catch (e) {
      throw Exception('Failed to add category: $e');
    }
  }

  @override
  Future<void> updateCategory({required CategoryModel categoryModel}) async {
    try {
      final existingCategory = categoryBox.get(categoryModel.id);
      if (existingCategory == null) {
        throw Exception('Category with ID ${categoryModel.id} not found');
      }
      if (existingCategory.isDefault) {
        throw Exception('cannot update default category');
      }
      if (existingCategory.slug != categoryModel.slug) {
        final duplicateSlug = categoryBox
            .query(
              CategoryModel_.slug.equals(categoryModel.slug),
            )
            .build()
            .findFirst();
        if (duplicateSlug != null) {
          throw Exception('Category with slug ${categoryModel.slug} already exists');
        }
      }
      categoryBox.put(categoryModel);
    } catch (e) {
      throw Exception('Failed to update category: $e');
    }
  }

  @override
  Future<void> deleteCategory({required int id}) async {
    try {
      final category = categoryBox.get(id);

      if (category == null) {
        throw Exception('Category not found');
      }

      // Prevent deleting default categories
      if (category.isDefault) {
        throw Exception('Default categories cannot be deleted');
      }

      categoryBox.remove(id);
    } catch (e) {
      throw Exception('Failed to delete category: $e');
    }
  }

  @override
  Future<List<CategoryModel>> getAllCategory() async {
    try {
      return categoryBox.getAll();
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }

  void defaultInitialization() async {
    print('CategoryDataSourceImpl.defaultInitialization initializing');
    if (categoryBox.isEmpty()) {
      final defaultCategory = [
        CategoryModel(name: 'Person', slug: 'person', isDefault: true),
        CategoryModel(name: 'Expense', slug: 'expense', isDefault: true),
        CategoryModel(name: 'Income', slug: 'income', isDefault: true),
        CategoryModel(name: 'Cash', slug: 'cash', isDefault: true),
        CategoryModel(name: 'Bank', slug: 'bank', isDefault: true),
      ];
      categoryBox.putMany(defaultCategory);
    } else {
      print('categoryBox is not empty and already exists');
    }
  }
}
