import 'package:expense_tracker/core/app_top_container.dart';
import 'package:expense_tracker/features/add_transaction/presentation/bloc/add_income_expense_bloc.dart';
import 'package:expense_tracker/features/ledger/domain_layer/entity/ledger_entity.dart';
import 'package:expense_tracker/features/ledger/presentation_layer/bloc/ledger_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailReportPageView extends StatelessWidget {
  final LedgerEntity ledgerEntity;
  const DetailReportPageView({
    required this.ledgerEntity,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppTopContainer(title: '${ledgerEntity.name} Ledger Report'),
          SingleChildScrollView(
            child: BlocBuilder<AddIncomeExpenseBloc, AddIncomeExpenseState>(
              builder: (context, state) {
                if (state is TransactionLoadingState) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is TransactionLoaded) {
                  var filteredTransactions = state.transactionsEntity.where((element) => element.ledgerFrom == ledgerEntity.name || element.ledgerTo == ledgerEntity.name).toList();
                  if (filteredTransactions.isEmpty) {
                    return Text('No transactions found for ${ledgerEntity.name}');
                  }
                  double openingBalanceValue = double.parse(ledgerEntity.openingBalance.toString());
                  double runningBalance = ledgerEntity.openingBalanceType == 'Dr' ? openingBalanceValue : -openingBalanceValue;
                  double runningBalance1 = ledgerEntity.openingBalanceType == 'Dr' ? openingBalanceValue : -openingBalanceValue;

                  for (var e in filteredTransactions) {
                    double amount = double.parse(e.amount);
                    var value = e.ledgerFrom == ledgerEntity.name ? -amount : amount;
                    runningBalance1 += value;
                  }

                  if (runningBalance1.toString() != ledgerEntity.closingBalance) {
                    // 📍 Dispatch event to update LedgerEntity after processing transactions
                    WidgetsBinding.instance.addPostFrameCallback(
                      (_) {
                        context.read<LedgerBloc>().add(
                              LedgerUpdateClickEvent(
                                ledgerEntity: ledgerEntity.copyWith(
                                  closingBalance: runningBalance.toString(),
                                ),
                              ),
                            );
                      },
                    );
                  }

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
                              DataCell(ledgerEntity.openingBalanceType == 'Dr'
                                  ? Text(ledgerEntity.openingBalance.toString(), style: Theme.of(context).textTheme.labelMedium)
                                  : Text('0', style: Theme.of(context).textTheme.labelMedium)),
                              DataCell(ledgerEntity.openingBalanceType == 'Cr'
                                  ? Text(ledgerEntity.openingBalance.toString(), style: Theme.of(context).textTheme.labelMedium)
                                  : Text('0', style: Theme.of(context).textTheme.labelMedium)),
                              DataCell(
                                Text(
                                  ledgerEntity.openingBalance.toString(),
                                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                        color: ledgerEntity.openingBalanceType == 'Dr' ? Colors.green : Colors.red,
                                      ),
                                ),
                              ),
                            ],
                          ),

                          ...filteredTransactions.map(
                            (e) {
                              double amount = double.parse(e.amount);
                              var value = e.ledgerFrom == ledgerEntity.name ? -amount : amount;
                              runningBalance += value;
                              Color balanceColor = runningBalance < 0 ? Colors.red : Colors.green;

                              return DataRow(
                                cells: [
                                  DataCell(Text(
                                    e.date.substring(0, 10),
                                    style: Theme.of(context).textTheme.labelMedium,
                                  )),
                                  DataCell(Text(
                                    e.ledgerFrom == ledgerEntity.name ? "To ${e.ledgerTo}" : "Received from ${e.ledgerFrom}",
                                    style: Theme.of(context).textTheme.labelMedium,
                                  )),
                                  DataCell(e.ledgerFrom == ledgerEntity.name
                                      ? Text(
                                          '0',
                                          style: Theme.of(context).textTheme.labelMedium,
                                        )
                                      : Text(
                                          e.amount,
                                          style: Theme.of(context).textTheme.labelMedium,
                                        )),
                                  DataCell(
                                    e.ledgerFrom == ledgerEntity.name
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
