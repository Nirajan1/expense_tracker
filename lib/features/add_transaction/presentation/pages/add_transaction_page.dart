import 'package:expense_tracker/core/app_colors.dart';
import 'package:expense_tracker/features/add_transaction/presentation/pages/add_income_expense.dart';
import 'package:expense_tracker/features/home/presentation/home_page.dart';
import 'package:expense_tracker/features/ledger/presentation_layer/bloc/ledger_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddTransactionPageView extends StatelessWidget {
  const AddTransactionPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _topContainer(context),
          Image.asset(
            'assets/images/add.png',
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width * 0.4,
          ),
          Text(
            'What kind of transaction is it?',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            'Add your income and expense',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 38),
          _rowCardWidgets(context)
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
          'Add transaction',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: AppColors.whiteColor,
              ),
        ),
        SizedBox(height: 16),
      ],
    ),
  );
}

Widget _rowCardWidgets(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 12,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AddIncomeExpensePageView(
                  title: 'Income',
                ),
              ));
              context.read<LedgerBloc>().add(GetAllLedgersClickEvent());
            },
            child: CustomCardWidget(
              height: 180,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.arrow_upward_outlined,
                        size: 29,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Income',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    'Add your income',
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AddIncomeExpensePageView(
                  title: 'Expense',
                ),
              ));
              context.read<LedgerBloc>().add(GetAllLedgersClickEvent());
            },
            child: CustomCardWidget(
              height: 180,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.redAccent,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.arrow_downward_outlined,
                        size: 29,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Expense',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    'Add your Expense',
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
