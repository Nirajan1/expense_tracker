import 'package:expense_tracker/features/auth/domain_layer/repositories/sign_up_repositories.dart';
import 'package:expense_tracker/features/auth/domain_layer/sign_in_up_entity.dart/sign_up_entity.dart';

class SignUpUseCase {
  final SignUpRepositories signUpRepositories;
  SignUpUseCase({required this.signUpRepositories});
  Future<void> signUp({required SignUpEntity user}) {
    return signUpRepositories.signUp(user: user);
  }
}
