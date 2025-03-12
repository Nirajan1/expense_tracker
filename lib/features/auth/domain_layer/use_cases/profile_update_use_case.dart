import 'package:expense_tracker/features/auth/domain_layer/repositories/sign_up_repositories.dart';
import 'package:expense_tracker/features/auth/domain_layer/sign_in_up_entity.dart/sign_up_entity.dart';

class ProfileUpdateUseCase {
  final SignUpRepositories signUpRepositories;
  const ProfileUpdateUseCase({required this.signUpRepositories});
  Future<void> updateProfile({required SignUpEntity profile}) async {
    return await signUpRepositories.updateProfile(profile: profile);
  }
}
