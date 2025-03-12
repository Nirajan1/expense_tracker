import 'package:expense_tracker/core/app_card_layout.dart';
import 'package:expense_tracker/core/app_colors.dart';
import 'package:expense_tracker/features/ledger/domain_layer/entity/ledger_entity.dart';
import 'package:expense_tracker/features/ledger/presentation_layer/bloc/ledger_bloc.dart';
import 'package:expense_tracker/features/report/presentation/pages/detail_report_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReportPageView extends StatefulWidget {
  const ReportPageView({super.key});

  @override
  State<ReportPageView> createState() => _ReportPageViewState();
}

class _ReportPageViewState extends State<ReportPageView> {
  // @override
  // void initState() {
  //   super.initState();
  //   context.read<LedgerBloc>().add(GetAllLedgersClickEvent());
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _topContainer(context),
          SingleChildScrollView(
            child: SingleChildScrollView(
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
          )
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
          //   child: CardWidget(
          //     title: 'Category',
          //     onTap: () {},
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
          //   child: CardWidget(
          //     title: 'Ledger',
          //     onTap: () {},
          //   ),
          // ),
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
      children: [SizedBox(height: MediaQuery.of(context).size.height * 0.1), Text('Report', style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: AppColors.whiteColor)), SizedBox(height: 16)],
    ),
  );
}

class CategoryListWidget extends StatelessWidget {
  const CategoryListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [ListTile(title: Text('Category List', style: Theme.of(context).textTheme.displayMedium), trailing: Icon(Icons.arrow_forward_outlined))]);
  }
}

Widget _buildCard(BuildContext context, LedgerEntity ledgerEntity) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 18.0),
    child: InkWell(
      onTap: () {
        final ledgerEntityValue = LedgerEntity(
          id: ledgerEntity.id,
          name: ledgerEntity.name,
          categoryType: ledgerEntity.categoryType,
          openingBalance: ledgerEntity.openingBalance,
          openingBalanceType: ledgerEntity.openingBalanceType,
          closingBalance: ledgerEntity.closingBalance,
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailReportPageView(
              ledgerEntity: ledgerEntityValue,
            ),
          ),
        );
      },
      child: AppCardLayoutView(
        child: ListTile(
          title: Row(
            children: [
              Text(ledgerEntity.name),
              Spacer(),
              Text(
                "Type : ${ledgerEntity.categoryType.toString()}",
                style: Theme.of(context).textTheme.labelMedium!.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 4,
            children: [
              Text(
                'Opening BLC : ${ledgerEntity.openingBalance.toString()}',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              Text(
                'Closing BLC : ${ledgerEntity.closingBalance.toString()}',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ],
          ),
          // trailing: BlocBuilder<LedgerBloc, LedgerState>(
          //   builder: (context, state) {
          //     if (state is LedgerLoadedSuccessState) {
          //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Deleted successfully')));
          //     }
          //     return InkWell(
          //       onTap: () {
          //         context.read<LedgerBloc>().add(LedgerDeleteClickEvent(ledgerId: ledgerEntity.id!.toInt()));
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
