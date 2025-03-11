import 'package:expense_tracker/features/auth/domain_layer/repositories/sign_in_repositories.dart';

class SignInUseCase {
  final SignInRepositories signInRepositories;
  SignInUseCase({required this.signInRepositories});
  Future<SignInRepositories> getSignIn({required String userName, required String passWord}) {
    return signInRepositories.getSignIn(userName: userName, passWord: passWord);
  }
}
