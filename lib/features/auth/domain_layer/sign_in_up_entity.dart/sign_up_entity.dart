import 'package:equatable/equatable.dart';

class SignUpEntity extends Equatable {
  final int? id;
  final String userName;
  final String phoneNumber;
  final String address;
  final String passwordHash;

  const SignUpEntity({
    this.id,
    required this.userName,
    required this.phoneNumber,
    required this.address,
    required this.passwordHash,
  });

  @override
  List<Object?> get props => [
        id,
        userName,
        phoneNumber,
        address,
        passwordHash,
      ];
}
