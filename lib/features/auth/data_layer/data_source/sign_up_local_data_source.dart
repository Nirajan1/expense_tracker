import 'package:expense_tracker/features/auth/data_layer/model/sign_up_model.dart';
import 'package:expense_tracker/objectbox.g.dart';
import 'package:flutter/widgets.dart';

abstract class SignUpLocalDataSource {
  Future<void> signUp({required SignUpModel signUpModel});
  Future<SignUpModel?> getUserByUserName(String userName);
  Future<void> updateuserProfile({required SignUpModel profileModel});
}

class SignUpLocalDataSourceImpl implements SignUpLocalDataSource {
  final Store store;
  late final Box<SignUpModel> signUpModelBox;
  SignUpLocalDataSourceImpl({required this.store}) {
    signUpModelBox = store.box<SignUpModel>();
  }

  @override
  Future<void> signUp({required SignUpModel signUpModel}) async {
    try {
      // Check if a user with the same phone number already exists
      final existingUserQuery = signUpModelBox.query(SignUpModel_.phoneNumber.equals(signUpModel.phoneNumber)).build();
      final existingUser = existingUserQuery.findFirst();
      existingUserQuery.close();

      if (existingUser != null) {
        debugPrint('User with phone number ${signUpModel.phoneNumber} already exists');
        throw Exception('User with this phone number already exists');
      }

      // If the phone number is unique, add the new user
      signUpModelBox.put(signUpModel);
      debugPrint('User signed up successfully: ${signUpModel.userName}');
    } catch (e) {
      debugPrint('Error signing up user: $e');
      rethrow;
    }
  }

  @override
  Future<SignUpModel?> getUserByUserName(String userName) async {
    try {
      // final query = signUpModelBox.query(SignUpModel_.userName.equals(userName)).build();
      // // Debug: Check if username exists before querying
      // final allUsers = signUpModelBox.getAll();
      // debugPrint('Searching for username: "$userName"');
      // debugPrint('All stored usernames: ${allUsers.map((e) => e.userName).toList()}');
      final trimmedUserName = userName.trim(); // Trim spaces before searching
      final query = signUpModelBox.query(SignUpModel_.userName.equals(trimmedUserName)).build();

      final user = query.findFirst();
      query.close();
      if (user == null) {
        debugPrint('No user found with username: $userName');
      } else {
        debugPrint('User found: ${user.userName}');
      }
      print(user);
      return user;
    } catch (e) {
      debugPrint('Error retrieving user by username: $e');
      return null;
    }
  }

  @override
  Future<void> updateuserProfile({required SignUpModel profileModel}) async {
    signUpModelBox.put(profileModel);
  }
}
