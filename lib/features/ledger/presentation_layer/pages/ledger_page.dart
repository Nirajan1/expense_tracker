import 'package:expense_tracker/core/app_card_layout.dart';
import 'package:expense_tracker/core/app_colors.dart';
import 'package:expense_tracker/core/app_top_container.dart';
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppTopContainer(title: 'Ledger List'),
            BlocBuilder<LedgerBloc, LedgerState>(
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
          ],
        ),
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
        trailing: BlocBuilder<LedgerBloc, LedgerState>(
          builder: (context, state) {
            if (state is LedgerLoadedSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Deleted successfully')));
            }
            return InkWell(
              onTap: () {
                context.read<LedgerBloc>().add(LedgerDeleteClickEvent(ledgerId: ledgerEntity.id!.toInt()));
              },
              child: Icon(
                Icons.delete_outline,
                color: Colors.redAccent,
              ),
            );
          },
        ),
      ),
    ),
  );
}
