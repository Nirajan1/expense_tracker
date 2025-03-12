part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class SignUpClickEvent extends AuthEvent {
  final SignUpEntity signUpEntity;
  const SignUpClickEvent({required this.signUpEntity});
  @override
  List<Object> get props => [signUpEntity];
}

class TogglePasswordVisibilityEvent extends AuthEvent {}

class GetUserBynameClickEvent extends AuthEvent {
  final String userName;
  const GetUserBynameClickEvent({
    required this.userName,
  });

  @override
  List<Object> get props => [userName];
}

class SignInClickEvent extends AuthEvent {
  final String userName;
  final String password;
  const SignInClickEvent({
    required this.userName,
    required this.password,
  });
  @override
  List<Object> get props => [userName, password];
}

// profie page update
class ProfileUpDateClickEvent extends AuthEvent {
  final SignUpEntity signUpEntity;
  final String userName;
  const ProfileUpDateClickEvent({
    required this.signUpEntity,
    required this.userName,
  });
  @override
  List<Object> get props => [signUpEntity, userName];
}
