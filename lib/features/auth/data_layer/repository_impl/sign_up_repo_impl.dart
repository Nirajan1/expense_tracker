import 'package:expense_tracker/features/auth/data_layer/data_source/sign_up_local_data_source.dart';
import 'package:expense_tracker/features/auth/data_layer/model/sign_up_model.dart';
import 'package:expense_tracker/features/auth/domain_layer/repositories/sign_up_repositories.dart';
import 'package:expense_tracker/features/auth/domain_layer/sign_in_up_entity.dart/sign_up_entity.dart';

class SignUpRepoImpl implements SignUpRepositories {
  final SignUpLocalDataSource signUpLocalDataSource;
  SignUpRepoImpl({required this.signUpLocalDataSource});
  @override
  Future<void> signUp({required SignUpEntity user}) async {
    final signUpModel = SignUpModel(userName: user.userName, phoneNumber: user.phoneNumber, address: user.address, passwordHash: user.passwordHash);
    signUpLocalDataSource.signUp(signUpModel: signUpModel);
    print(signUpModel);
  }

  @override
  Future<SignUpEntity?> getUser({required String userName}) async {
    print('Sign up repo impl $userName');
    final signUpModel = await signUpLocalDataSource.getUserByUserName(userName);

    if (signUpModel == null) {
      return null; // Return null safely
    }

    print(signUpModel.passwordHash.toString());
    return signUpModel.toEntity();
  }

  @override
  Future<void> updateProfile({required SignUpEntity profile}) async {
    final profileModel = SignUpModel.fromEntity(profile);
    return await signUpLocalDataSource.updateuserProfile(profileModel: profileModel);
  }
}
