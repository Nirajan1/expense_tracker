part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

class SignUpClickLoadingState extends AuthState {}

class SignUpClickErrorState extends AuthState {
  final String errorMessage;
  const SignUpClickErrorState({required this.errorMessage});
}

class SignUpLoadingSuccessState extends AuthState {
  final String successMessage;
  const SignUpLoadingSuccessState({required this.successMessage});
}

class PasswordVisibleState extends AuthState {
  final bool isPasswordVisible;

  const PasswordVisibleState({required this.isPasswordVisible});
}

class PasswordHiddenState extends AuthState {
  final bool isPasswordVisible;

  const PasswordHiddenState({required this.isPasswordVisible});
}

// get user by name state
class GetUserBynameClickLoadingState extends AuthState {}

class GetUserByNameLoadedState extends AuthState {
  final SignUpEntity? signUpEntity;
  const GetUserByNameLoadedState({required this.signUpEntity});
  @override
  List<Object> get props => [signUpEntity!];
}

// for sign in
class SignInClickLoadingState extends AuthState {
  final String value;
  const SignInClickLoadingState(this.value);
  @override
  List<Object> get props => [value];
}

class SignInClickErrorState extends AuthState {
  final String errorMessage;
  const SignInClickErrorState({required this.errorMessage});
}

class SignInLoadingSuccessState extends AuthState {
  final SignUpEntity successMessage;
  const SignInLoadingSuccessState({required this.successMessage});
}

// profile update states
class ProfileUpDateClickLoadingState extends AuthState {}

class ProfileUpDateClickErrorState extends AuthState {
  final String message;
  const ProfileUpDateClickErrorState({required this.message});
  @override
  List<Object> get props => [message];
}

class ProfileUpDateClickLoadedState extends AuthState {
  final String signUpEntity;
  const ProfileUpDateClickLoadedState({
    required this.signUpEntity,
  });
  @override
  List<Object> get props => [signUpEntity];
}
