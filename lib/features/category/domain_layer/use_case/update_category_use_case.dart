import 'package:expense_tracker/features/category/domain_layer/entity/category_entity.dart';
import 'package:expense_tracker/features/category/domain_layer/repositories/category_repositories.dart';

class UpdateCategoryUseCase {
  final CategoryRepositories categoryRepositories;
  UpdateCategoryUseCase({required this.categoryRepositories});
  Future<void> updateCategory({required CategoryEntity categoryEntity}) async {
    return await categoryRepositories.updateCategory(categoryEntity: categoryEntity);
  }
}
