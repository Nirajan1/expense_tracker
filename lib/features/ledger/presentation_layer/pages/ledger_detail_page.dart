import 'package:expense_tracker/core/app_top_container.dart';
import 'package:expense_tracker/features/add_transaction/presentation/bloc/add_income_expense_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LedgerDetailPageView extends StatelessWidget {
  final String name;
  final String ledgerCategory;
  const LedgerDetailPageView({required this.name, required this.ledgerCategory, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppTopContainer(title: '$name Ledger Report'),
          SingleChildScrollView(
            child: BlocBuilder<AddIncomeExpenseBloc, AddIncomeExpenseState>(
              builder: (context, state) {
                if (state is TransactionLoadingState) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is TransactionLoaded) {
                  var filteredTransactions = state.transactionsEntity.where((element) => element.ledgerFrom == name || element.ledgerTo == name).toList();
                  if (filteredTransactions.isEmpty) {
                    return Text('No transactions found for $name');
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        horizontalMargin: 1,
                        // columnSpacing: 14,
                        columns: [DataColumn(label: Text('Date')), DataColumn(label: Text('Particular')), DataColumn(label: Text('Dr')), DataColumn(label: Text('Cr'))],
                        rows:
                            filteredTransactions.map((e) {
                              // bool isIncome = e.type == 'income';

                              return DataRow(
                                cells: [
                                  DataCell(Text(e.date.substring(0, 10))),
                                  DataCell(Text(e.ledgerFrom == name ? "To ${e.ledgerTo}" : "Received from ${e.ledgerFrom}")),
                                  DataCell(e.ledgerFrom == name ? Text('0') : Text(e.amount)),
                                  DataCell(e.ledgerFrom == name ? Text(e.amount) : Text('0')),
                                ],
                              );
                            }).toList(),
                      ),
                    ),
                  );

                  // ListView.builder(
                  //   itemCount: filteredTransactions.length,
                  //   shrinkWrap: true,
                  //   physics: const NeverScrollableScrollPhysics(),
                  //   itemBuilder: (BuildContext context, int index) {
                  //     var transaction = filteredTransactions[index];
                  //     return Padding(
                  //       padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  //       child: AppCardLayoutView(
                  //         child: Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             ListTile(
                  //               title: Row(
                  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //                 children: [
                  //                   Row(
                  //                     children: [
                  //                       Text('From : '),
                  //                       Text(state.transactionsEntity[index].ledgerFrom),
                  //                     ],
                  //                   ),
                  //                   Text(
                  //                     transaction.type[0].toUpperCase() + transaction.type.substring(1),
                  //                     style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  //                           color: isIncome ? Colors.green : Colors.amber[900],
                  //                         ),
                  //                   ),
                  //                 ],
                  //               ),
                  //               subtitle: Row(
                  //                 children: [
                  //                   Text('To : '),
                  //                   Text(state.transactionsEntity[index].ledgerTo),
                  //                 ],
                  //               ),
                  //             ),
                  //             Padding(
                  //               padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  //               child: Text('Date : ${state.transactionsEntity[index].date}'),
                  //             ),
                  //             const SizedBox(height: 6),
                  //             Padding(
                  //               padding: const EdgeInsets.all(8.0),
                  //               child: Column(
                  //                 children: [
                  //                   Row(
                  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //                     children: [
                  //                       Expanded(
                  //                         child: Container(
                  //                             decoration: BoxDecoration(
                  //                               border: Border(
                  //                                 right: BorderSide(color: AppColors.primaryColor),
                  //                                 left: BorderSide(color: AppColors.primaryColor),
                  //                                 bottom: BorderSide(color: AppColors.primaryColor),
                  //                                 top: BorderSide(color: AppColors.primaryColor),
                  //                               ),
                  //                             ),
                  //                             child: Center(child: Text('Dr'))),
                  //                       ),
                  //                       Expanded(
                  //                         child: Container(
                  //                           decoration: BoxDecoration(
                  //                               border: Border(
                  //                             right: BorderSide(color: AppColors.primaryColor),
                  //                             top: BorderSide(color: AppColors.primaryColor),
                  //                             bottom: BorderSide(color: AppColors.primaryColor),
                  //                           )),
                  //                           child: Center(
                  //                             child: Text('Cr'),
                  //                           ),
                  //                         ),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                   Row(
                  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //                     children: [
                  //                       // If it's an income, show the amount in Dr, Cr will be 0
                  //                       Expanded(
                  //                         child: Container(
                  //                           decoration: BoxDecoration(
                  //                             border: Border(
                  //                               right: BorderSide(color: AppColors.primaryColor),
                  //                               left: BorderSide(color: AppColors.primaryColor),
                  //                               bottom: BorderSide(color: AppColors.primaryColor),
                  //                             ),
                  //                           ),
                  //                           child: Center(
                  //                             child: isIncome ? Text(transaction.amount) : Text('0'),
                  //                           ),
                  //                         ),
                  //                       ),
                  //                       Expanded(
                  //                         child: Container(
                  //                           decoration: BoxDecoration(
                  //                             border: Border(
                  //                               right: BorderSide(color: AppColors.primaryColor),
                  //                               bottom: BorderSide(color: AppColors.primaryColor),
                  //                             ),
                  //                           ),
                  //                           child: Center(
                  //                             child: !isIncome ? Text(transaction.amount) : Text('0'),
                  //                           ),
                  //                         ),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     );
                  //   },
                  // );
                } else if (state is TransactionErrorState) {
                  return Text('Error: ${state.error}');
                } else {
                  return Text('No data available');
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
