import 'package:expense_tracker/features/auth/data_layer/data_source/sign_up_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:expense_tracker/features/auth/data_layer/model/sign_up_model.dart';
import 'package:expense_tracker/objectbox.g.dart';

void main() {
  late Store store;
  late SignUpLocalDataSourceImpl signUpLocalDataSource;

  setUp(() {
    // Initialize the ObjectBox store
    store = Store(getObjectBoxModel());
    signUpLocalDataSource = SignUpLocalDataSourceImpl(store: store);
  });

  tearDown(() {
    // Close the ObjectBox store after each test
    store.close();
  });

  group('SignUpLocalDataSourceImpl', () {
    test('signUp and getUserByUserName', () async {
      // Arrange
      final signUpModel = SignUpModel(
        userName: 'testUser',
        phoneNumber: 'testNumber',
        address: 'testAddress',
        passwordHash: 'testPasswordHash',
      );

      // Act
      await signUpLocalDataSource.signUp(signUpModel: signUpModel);

      // Assert
      final user = await signUpLocalDataSource.getUserByUserName('testUser');
      expect(user?.userName, 'testUser');
    });

    test('getUserByUserName returns null for non-existent user', () async {
      // Act
      final user = await signUpLocalDataSource.getUserByUserName('nonExistentUser');

      // Assert
      expect(user, isNull);
    });
  });
}
