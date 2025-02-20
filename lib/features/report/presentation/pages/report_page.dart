import 'package:expense_tracker/core/app_colors.dart';
import 'package:flutter/material.dart';

class ReportPageView extends StatelessWidget {
  const ReportPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _topContainer(context),
        ],
      ),
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
          'Report',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: AppColors.whiteColor,
              ),
        ),
        SizedBox(height: 16),
      ],
    ),
  );
}

class CategoryListWidget extends StatelessWidget {
  const CategoryListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(
            'Category List',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          trailing: Icon(Icons.arrow_forward_outlined),
        )
      ],
    );
  }
}
