import 'package:expense_tracker/features/category/domain_layer/entity/category_entity.dart';
import 'package:expense_tracker/features/category/domain_layer/repositories/category_repositories.dart';

class AddCategoryUseCase {
  final CategoryRepositories categoryRepositories;
  const AddCategoryUseCase({required this.categoryRepositories});
  Future<void> addCategory({required CategoryEntity categoryEntity}) async {
    return await categoryRepositories.addCategory(categoryEntity: categoryEntity);
  }
}
