import 'package:expense_tracker/core/app_colors.dart';

import 'package:flutter/material.dart';

class ProfilePageView extends StatelessWidget {
  const ProfilePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16,
      children: [
        _topContainer(context),
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
