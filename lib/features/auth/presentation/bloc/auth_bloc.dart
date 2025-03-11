import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_tracker/features/auth/domain_layer/sign_in_up_entity.dart/sign_up_entity.dart';
import 'package:expense_tracker/features/auth/domain_layer/use_cases/get_user_use_case.dart';
import 'package:expense_tracker/features/auth/domain_layer/use_cases/sign_up_use_case.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignUpUseCase signUpUseCase;
  final GetUserUseCase getUserUseCase;
  AuthBloc({required this.signUpUseCase, required this.getUserUseCase}) : super(AuthInitial()) {
    on<SignUpClickEvent>(signUpClickEvent);
    on<TogglePasswordVisibilityEvent>(togglePasswordVisibilityEvent);
    // on<GetUserBynameClickEvent>(getUserBynameClickEvent);
    on<SignInClickEvent>(signInClickEvent);
  }

  FutureOr<void> signUpClickEvent(SignUpClickEvent event, Emitter<AuthState> emit) async {
    emit(SignUpClickLoadingState());
    try {
      await Future.delayed(const Duration(seconds: 1));
      final user = await getUserUseCase.getUser(userName: event.signUpEntity.userName);
      print(user);
      if (user == null) {
        await signUpUseCase.signUp(user: event.signUpEntity);
        emit(SignUpLoadingSuccessState(successMessage: 'User Created Successfully'));
      } else if (user.phoneNumber == event.signUpEntity.phoneNumber) {
        emit(SignUpClickErrorState(errorMessage: 'User already exists with this number'));
      } else {
        emit(SignUpClickErrorState(errorMessage: 'Unknow! Error'));
      }
    } catch (e) {
      emit(SignUpClickErrorState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> togglePasswordVisibilityEvent(TogglePasswordVisibilityEvent event, Emitter<AuthState> emit) async {
    // Toggle the password visibility state.
    final currentState = state;
    if (currentState is PasswordVisibleState) {
      emit(PasswordHiddenState(isPasswordVisible: false));
    } else {
      emit(PasswordVisibleState(isPasswordVisible: true));
    }
  }

  // FutureOr<void> getUserBynameClickEvent(GetUserBynameClickEvent event, Emitter<AuthState> emit) async {
  //   print('insideBloc ${event.userName}');
  //   final userEntity = await getUserUseCase.getUser(userName: event.userName);
  //   print('entity is $userEntity');
  //   emit(GetUserByNameState(signUpEntity: userEntity));
  // }

  FutureOr<void> signInClickEvent(SignInClickEvent event, Emitter<AuthState> emit) async {
    emit(SignInClickLoadingState('loding'));
    try {
      await Future.delayed(const Duration(seconds: 1));
      final user = await getUserUseCase.getUser(userName: event.userName);
      print('user $user');
      if (user == null) {
        emit(SignInClickErrorState(errorMessage: 'User not found! Please sign up.'));
      } else if (user.passwordHash != event.password) {
        emit(SignInClickErrorState(errorMessage: 'Incorrect password! Please try again.'));
      } else {
        print('herer');
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('loggedIn', true);
        emit(SignInLoadingSuccessState(successMessage: user));
      }
    } catch (e) {
      emit(SignInClickErrorState(errorMessage: e.toString()));
    }
  }
}
