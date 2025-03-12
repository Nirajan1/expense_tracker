import 'package:expense_tracker/core/app_colors.dart';
import 'package:expense_tracker/features/transaction/presentation/widgets/secondary_tab_bar.dart';
import 'package:flutter/material.dart';

class TransactionPageView extends StatefulWidget {
  const TransactionPageView({super.key});

  @override
  State<TransactionPageView> createState() => _TransactionPageViewState();
}

class _TransactionPageViewState extends State<TransactionPageView> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _topContainer(context),
        const SizedBox(height: 10),
        Expanded(
          child: SecondaryTabBar(radius: 10),
        ),
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
          'Transaction',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: AppColors.whiteColor,
              ),
        ),
        SizedBox(height: 16),
      ],
    ),
  );
}
