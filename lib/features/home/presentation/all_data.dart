import 'package:expense_tracker/core/app_card_layout.dart';
import 'package:expense_tracker/core/app_colors.dart';
import 'package:expense_tracker/features/add_transaction/presentation/bloc/add_income_expense_bloc.dart';
import 'package:expense_tracker/features/transaction_detail_edit/presentation/pages/transaction_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllDataPageView extends StatelessWidget {
  const AllDataPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildTopContainer(context),
            BlocBuilder<AddIncomeExpenseBloc, AddIncomeExpenseState>(
              builder: (context, state) {
                if (state is TransactionLoadingState) {
                  return CircularProgressIndicator();
                } else if (state is TransactionLoaded) {
                  if (state.transactionsEntity.isEmpty) {
                    return Text(
                      'No transactions available',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    );
                  }
                  int itemCount = state.transactionsEntity.length;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: itemCount,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return _buildAllDataCard(
                          context,
                          title: state.transactionsEntity[index].type[0].toUpperCase() + state.transactionsEntity[index].type.substring(1),
                          price: state.transactionsEntity[index].amount,
                          date: state.transactionsEntity[index].date,
                          index: index,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TransactionDetailPageView(
                                  index: index,
                                  transactionEntity: state.transactionsEntity[index],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                } else if (state is TransactionErrorState) {
                  return Text('Error loading transactions');
                } else {
                  return Text('No transactions found');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildTopContainer(BuildContext context) {
  return Container(
    width: double.infinity,
    height: MediaQuery.of(context).size.height * 0.18,
    color: AppColors.primaryColor,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.1),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_outlined, color: AppColors.whiteColor),
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(width: 8),
              Text(
                'All Transactions',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    ),
  );
}

Widget _buildAllDataCard(
  BuildContext context, {
  required String title,
  required String price,
  required String date,
  required int index,
  required VoidCallback onTap,
}) {
  return AppCardLayoutView(
    child: ListTile(
      onTap: onTap,
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: title == 'Expense' ? Colors.amber : Colors.green,
          shape: BoxShape.circle,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        spacing: 4,
        children: [
          Icon(
            title == 'Expense' ? Icons.arrow_downward : Icons.arrow_upward,
            color: title == 'Expense' ? Colors.red : Colors.green,
            size: 16,
          ),
          Text(
            'Rs $price',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 18,
              color: title == 'Expense' ? Colors.red : Colors.green,
            ),
          ),
          // const SizedBox(width: 4),
          // BlocListener<AddIncomeExpenseBloc, AddIncomeExpenseState>(
          //   listener: (context, state) {},
          //   child: GestureDetector(
          //       onTap: () {
          //         context.read<AddIncomeExpenseBloc>().add(DeleteIncomeExpenseClickEvent(transactionId: index));
          //       },
          //       child: Icon(
          //         Icons.delete,
          //         color: Colors.redAccent,
          //       )),
          // ),
        ],
      ),
      title: Text(title),
      subtitle: Text(
        date,
        style: TextStyle(
          fontSize: 12,
        ),
      ),
    ),
  );
}
