import 'package:expense_tracker/core/app_card_layout.dart';
import 'package:expense_tracker/core/app_colors.dart';
import 'package:expense_tracker/core/app_snack_bar.dart';
import 'package:expense_tracker/core/app_top_container.dart';
import 'package:expense_tracker/features/add_transaction/presentation/bloc/add_income_expense_bloc.dart';
import 'package:expense_tracker/features/ledger/domain_layer/entity/ledger_entity.dart';
import 'package:expense_tracker/features/ledger/presentation_layer/bloc/ledger_bloc.dart';
import 'package:expense_tracker/features/ledger/presentation_layer/pages/add_ledger_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LedgerPageView extends StatelessWidget {
  const LedgerPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppTopContainer(title: 'Ledger List'),
          SingleChildScrollView(
            child: BlocBuilder<LedgerBloc, LedgerState>(
              builder: (context, state) {
                if (state is LedgerLoadingState) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is LedgerLoadedState) {
                  if (state.ledgerList.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
                        child: Text(
                          'No Ledger found',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: state.ledgerList.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return _buildCard(context, state.ledgerList[index]);
                    },
                  );
                } else if (state is LegerErrorState) {
                  return Text(
                    state.error,
                  );
                } else {
                  return Text('No Ledger found error');
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddLedgerPageView()));
        },
        shape: CircleBorder(),
        backgroundColor: AppColors.primaryColor,
        child: Icon(
          Icons.add_outlined,
          color: Colors.white,
        ),
      ),
    );
  }
}

Widget _buildCard(BuildContext context, LedgerEntity ledgerEntity) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 18.0),
    child: InkWell(
      onTap: () {},
      child: AppCardLayoutView(
        child: ListTile(
            title: Text(ledgerEntity.name),
            subtitle: Row(
              spacing: 4,
              children: [
                Text(ledgerEntity.openingBalanceType.toString()),
                Text(ledgerEntity.openingBalance.toString()),
                SizedBox(width: 8),
                Text(
                  ledgerEntity.categoryType.toString(),
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            trailing: IconButton(
              onPressed: () async {
                // Fetch transactions associated with the ledger
                context.read<AddIncomeExpenseBloc>().add(IncomeExpenseLoadEvent());
                // Wait for the state to update
                await Future.delayed(Duration(milliseconds: 500));
                // Check if the ledger has transactions
                if (context.mounted) {
                  final state = context.read<AddIncomeExpenseBloc>().state;
                  if (state is TransactionLoaded) {
                    final transactions = state.transactionsEntity.where((transaction) => transaction.ledgerFrom == ledgerEntity.name || transaction.ledgerTo == ledgerEntity.name).toList();

                    if (transactions.isNotEmpty) {
                      // Show a message that the ledger cannot be deleted
                      if (context.mounted) {
                        AppSnackBar.showCustomSnackBar(context, 'Cannot delete ledger "${ledgerEntity.name}" because it has associated transactions.', true, isTop: true);
                      }
                    } else {
                      // Proceed with deletion
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Delete Ledger'),
                          content: Text('Are you sure you want to delete this ledger?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                context.read<LedgerBloc>().add(LedgerDeleteClickEvent(ledgerId: ledgerEntity.id!.toInt()));
                                Navigator.pop(context);
                              },
                              child: Text('Delete'),
                            ),
                          ],
                        ),
                      );
                    }
                  }
                }
              },
              icon: Icon(
                Icons.delete_outline,
                color: Colors.redAccent,
              ),
            )

            //  BlocBuilder<LedgerBloc, LedgerState>(
            //   builder: (context, state) {
            //     if (state is LedgerLoadedSuccessState) {
            //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Deleted successfully')));
            //     }
            //     return InkWell(
            //       onTap: () {
            //         // context.read<LedgerBloc>().add(LedgerDeleteClickEvent(ledgerId: ledgerEntity.id!.toInt()));
            //       },
            //       child: Icon(
            //         Icons.delete_outline,
            //         color: Colors.redAccent,
            //       ),
            //     );
            //   },
            // ),
            ),
      ),
    ),
  );
}
