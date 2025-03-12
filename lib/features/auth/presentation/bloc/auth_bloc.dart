import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_tracker/features/auth/domain_layer/sign_in_up_entity.dart/sign_up_entity.dart';
import 'package:expense_tracker/features/auth/domain_layer/use_cases/get_user_use_case.dart';
import 'package:expense_tracker/features/auth/domain_layer/use_cases/profile_update_use_case.dart';
import 'package:expense_tracker/features/auth/domain_layer/use_cases/sign_up_use_case.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignUpUseCase signUpUseCase;
  final GetUserUseCase getUserUseCase;
  final ProfileUpdateUseCase profileUpdateUseCase;
  AuthBloc({
    required this.signUpUseCase,
    required this.getUserUseCase,
    required this.profileUpdateUseCase,
  }) : super(AuthInitial()) {
    on<SignUpClickEvent>(signUpClickEvent);
    on<TogglePasswordVisibilityEvent>(togglePasswordVisibilityEvent);
    on<GetUserBynameClickEvent>(getUserBynameClickEvent);
    on<SignInClickEvent>(signInClickEvent);
    on<ProfileUpDateClickEvent>(profileUpdateClickEvent);
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
    final isCurrentlyVisible = state is PasswordVisibleState;
    emit(isCurrentlyVisible ? PasswordHiddenState(isPasswordVisible: false) : PasswordVisibleState(isPasswordVisible: true));
  }

  FutureOr<void> getUserBynameClickEvent(GetUserBynameClickEvent event, Emitter<AuthState> emit) async {
    emit(GetUserBynameClickLoadingState());
    try {
      // print('insideBloc ${event.userName}');
      final userEntity = await getUserUseCase.getUser(userName: event.userName);
      // print('entity is $userEntity');
      emit(GetUserByNameLoadedState(signUpEntity: userEntity));
    } catch (exception) {
      debugPrint('Error $exception');
    }
  }

  FutureOr<void> signInClickEvent(SignInClickEvent event, Emitter<AuthState> emit) async {
    emit(SignInClickLoadingState('loding'));
    try {
      await Future.delayed(const Duration(seconds: 1));
      final user = await getUserUseCase.getUser(userName: event.userName);
      // print('user $user');
      if (user == null) {
        emit(SignInClickErrorState(errorMessage: 'User not found! Please sign up.'));
      } else if (user.passwordHash != event.password) {
        emit(SignInClickErrorState(errorMessage: 'Incorrect password! Please try again.'));
      } else {
        // print('herer');
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('loggedIn', true);
        emit(SignInLoadingSuccessState(successMessage: user));
      }
    } catch (e) {
      emit(SignInClickErrorState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> profileUpdateClickEvent(ProfileUpDateClickEvent event, Emitter<AuthState> emit) async {
    emit(ProfileUpDateClickLoadingState());
    print(event.userName);
    print(event.signUpEntity);
    try {
      await Future.delayed(const Duration(seconds: 1));
      await profileUpdateUseCase.updateProfile(profile: event.signUpEntity);
      emit(ProfileUpDateClickLoadedState(signUpEntity: 'Profile Updated Successfully!'));
      add(GetUserBynameClickEvent(userName: event.userName));
    } catch (exception) {
      Future.delayed(const Duration(seconds: 1));
      print('error excpetion');
      emit(ProfileUpDateClickErrorState(message: exception.toString()));
    }
  }
}
