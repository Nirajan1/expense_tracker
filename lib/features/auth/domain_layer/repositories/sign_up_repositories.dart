import 'package:expense_tracker/features/auth/domain_layer/sign_in_up_entity.dart/sign_up_entity.dart';

abstract class SignUpRepositories {
  Future<void> signUp({required SignUpEntity user});
  Future<SignUpEntity?> getUser({required String userName});
  Future<void> updateProfile({required SignUpEntity profile});
}
