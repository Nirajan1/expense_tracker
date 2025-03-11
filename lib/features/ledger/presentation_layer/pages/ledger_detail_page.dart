import 'package:expense_tracker/core/app_top_container.dart';
import 'package:expense_tracker/features/add_transaction/presentation/bloc/add_income_expense_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LedgerDetailPageView extends StatelessWidget {
  final String name;
  final String ledgerCategory;
  final int openingBalance;
  final String openingBalanceType;
  const LedgerDetailPageView({
    required this.name,
    required this.ledgerCategory,
    required this.openingBalance,
    required this.openingBalanceType,
    super.key,
  });

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
                  double openingBalanceValue = double.parse(openingBalance.toString());
                  double runningBalance = openingBalanceType == 'Dr' ? openingBalanceValue : -openingBalanceValue;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        horizontalMargin: 1,
                        columnSpacing: 20,
                        headingTextStyle: Theme.of(context).textTheme.titleSmall,
                        columns: [
                          DataColumn(label: Text('Date')),
                          DataColumn(label: Text('Particular')),
                          DataColumn(label: Text('In')), //dr
                          DataColumn(label: Text('Out')), //cr
                          DataColumn(label: Text('Balance')),
                        ],
                        rows: [
                          //opening balance
                          DataRow(
                            cells: [
                              DataCell(Text('')),
                              DataCell(Text('Opening Balance', style: Theme.of(context).textTheme.labelMedium)),
                              DataCell(openingBalanceType == 'Dr'
                                  ? Text(openingBalance.toString(), style: Theme.of(context).textTheme.labelMedium)
                                  : Text('0', style: Theme.of(context).textTheme.labelMedium)),
                              DataCell(openingBalanceType == 'Cr'
                                  ? Text(openingBalance.toString(), style: Theme.of(context).textTheme.labelMedium)
                                  : Text('0', style: Theme.of(context).textTheme.labelMedium)),
                              DataCell(
                                Text(
                                  openingBalance.toString(),
                                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                        color: openingBalanceType == 'Dr' ? Colors.green : Colors.red,
                                      ),
                                ),
                              ),
                            ],
                          ),

                          ...filteredTransactions.map(
                            (e) {
                              // bool isIncome = e.type == 'income';

                              double amount = double.parse(e.amount);
                              var value = e.ledgerFrom == name ? -amount : amount;
                              runningBalance += value;
                              Color balanceColor = runningBalance < 0 ? Colors.red : Colors.green;
                              return DataRow(
                                cells: [
                                  DataCell(Text(
                                    e.date.substring(0, 10),
                                    style: Theme.of(context).textTheme.labelMedium,
                                  )),
                                  DataCell(Text(
                                    e.ledgerFrom == name ? "To ${e.ledgerTo}" : "Received from ${e.ledgerFrom}",
                                    style: Theme.of(context).textTheme.labelMedium,
                                  )),
                                  DataCell(e.ledgerFrom == name
                                      ? Text(
                                          '0',
                                          style: Theme.of(context).textTheme.labelMedium,
                                        )
                                      : Text(
                                          e.amount,
                                          style: Theme.of(context).textTheme.labelMedium,
                                        )),
                                  DataCell(
                                    e.ledgerFrom == name
                                        ? Text(
                                            e.amount,
                                            style: Theme.of(context).textTheme.labelMedium,
                                          )
                                        : Text(
                                            '0',
                                            style: Theme.of(context).textTheme.labelMedium,
                                          ),
                                  ),
                                  DataCell(
                                    Text(
                                      runningBalance.toInt().toString(),
                                      style: Theme.of(context).textTheme.labelMedium!.copyWith(color: balanceColor),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
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
