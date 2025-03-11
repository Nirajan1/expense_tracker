import 'package:expense_tracker/features/auth/domain_layer/sign_in_up_entity.dart/sign_up_entity.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class SignUpModel {
  @Id()
  int id = 0;
  @Index()
  final String userName;
  final String phoneNumber;
  final String address;
  final String passwordHash;

  SignUpModel({
    this.id = 0,
    required this.userName,
    required this.phoneNumber,
    required this.address,
    required this.passwordHash,
  });

  factory SignUpModel.fromEntity(SignUpEntity entity) {
    return SignUpModel(
      id: entity.id!.toInt(),
      userName: entity.userName,
      phoneNumber: entity.phoneNumber,
      address: entity.address,
      passwordHash: entity.passwordHash,
    );
  }

  SignUpEntity toEntity() {
    return SignUpEntity(
      id: id,
      userName: userName,
      phoneNumber: phoneNumber,
      address: address,
      passwordHash: passwordHash,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'phoneNumber': phoneNumber,
      'address': address,
      'passwordHash': passwordHash,
    };
  }
}
