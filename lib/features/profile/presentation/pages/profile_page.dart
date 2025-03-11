import 'package:expense_tracker/core/app_colors.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePageView extends StatelessWidget {
  const ProfilePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      // spacing: 16,
      children: [
        _topContainer(context),
        SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 16),
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/images/profile.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  String userName = 'Demo User';
                  if (state is SignInLoadingSuccessState) {
                    print(state.successMessage.userName);
                    userName = state.successMessage.userName;
                  } else {
                    print('no loading state');
                  }
                  return Text(userName);
                },
              ),
            ],
          ),
        )
      ],
    );
  }
}

Widget _topContainer(BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height * 0.18,
    color: AppColors.primaryColor,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.1),
        Text(
          'Profile',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: AppColors.whiteColor),
        ),
        SizedBox(height: 16),
      ],
    ),
  );
}
