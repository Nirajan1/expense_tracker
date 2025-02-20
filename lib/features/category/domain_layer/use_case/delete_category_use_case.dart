import 'package:expense_tracker/features/category/domain_layer/repositories/category_repositories.dart';

class DeleteCategoryUseCase {
  final CategoryRepositories categoryRepositories;
  const DeleteCategoryUseCase({required this.categoryRepositories});
  Future<void> deleteCategory({required int id}) async {
    return await categoryRepositories.deleteCategory(id: id);
  }
}
