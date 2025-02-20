import 'package:expense_tracker/features/category/domain_layer/entity/category_entity.dart';
import 'package:expense_tracker/features/category/domain_layer/repositories/category_repositories.dart';

class GetAllCategoryUseCase {
  final CategoryRepositories categoryRepositories;
  const GetAllCategoryUseCase({required this.categoryRepositories});
  Future<List<CategoryEntity>> getAllCategory() async {
    return await categoryRepositories.getCategories();
  }
}
