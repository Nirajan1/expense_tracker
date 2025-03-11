import 'package:expense_tracker/features/auth/domain_layer/repositories/sign_up_repositories.dart';
import 'package:expense_tracker/features/auth/domain_layer/sign_in_up_entity.dart/sign_up_entity.dart';

class GetUserUseCase {
  final SignUpRepositories signUpRepositories;
  const GetUserUseCase({required this.signUpRepositories});
  Future<SignUpEntity?> getUser({required String userName}) async {
    print('get user use case $userName');
    return await signUpRepositories.getUser(userName: userName);
  }
}
