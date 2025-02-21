import 'package:expense_tracker/core/app_colors.dart';
import 'package:expense_tracker/core/app_top_container.dart';
import 'package:expense_tracker/features/add_transaction/domain_layer/entity/transaction_entity.dart';
import 'package:expense_tracker/features/add_transaction/presentation/bloc/add_income_expense_bloc.dart';
import 'package:expense_tracker/features/ledger/presentation_layer/bloc/ledger_bloc.dart';
import 'package:expense_tracker/features/transaction_detail_edit/presentation/pages/transaction_detail_edit_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionDetailPageView extends StatelessWidget {
  final int index;
  final TransactionEntity transactionEntity;
  const TransactionDetailPageView({
    required this.index,
    required this.transactionEntity,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          spacing: 12,
          children: [
            AppTopContainer(title: 'Transaction detail'),
            _buildCardTile(
              context,
              title: transactionEntity.type[0].toUpperCase() + transactionEntity.type.substring(1),
              price: transactionEntity.amount,
              date: transactionEntity.date,
              index: transactionEntity.id,
              callback: () {
                print(transactionEntity.id);
                context.read<LedgerBloc>().add(GetAllLedgersClickEvent());
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TransactionDetailEditPageView(
                      transactionEntity: transactionEntity,
                    ),
                  ),
                );
              },
            ),
            _buildInputField(context, 'Transaction Type', transactionEntity.type.toUpperCase()),
            _buildInputField(context, 'Transaction Date', transactionEntity.date),
            _buildCategory(context, ' From', transactionEntity.categoryFrom),
            _buildCategory(context, ' To', transactionEntity.categoryTo),
            _buildInputField(context, 'Amount', transactionEntity.amount)
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(BuildContext context, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 14),
          TextFormField(
            // controller: _transactionAmountController,
            readOnly: true,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: title == 'Amount' ? 'Rs $value' : value,
              hintStyle: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategory(BuildContext context, String title, String selectedValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Transaction Ledger $title',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 14),
          ButtonTheme(
            alignedDropdown: true,
            child: DropdownButtonFormField(
              value: selectedValue,
              style: Theme.of(context).textTheme.labelLarge,
              dropdownColor: AppColors.whiteColor,
              hint: Text(selectedValue),
              items: [],
              onChanged: (value) {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardTile(
    BuildContext context, {
    required String title,
    required String price,
    required String date,
    required int? index,
    required VoidCallback callback,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16, top: 16, left: 16, right: 16),
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(-3, 6), // changes position of shadow
          ),
        ],
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
          ),
          left: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
      ),
      child: ListTile(
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
            InkWell(
              onTap: callback,
              child: Icon(
                Icons.edit_outlined,
                color: AppColors.secondaryColor,
              ),
            ),
            const SizedBox(width: 4),
            BlocListener<AddIncomeExpenseBloc, AddIncomeExpenseState>(
              listener: (context, state) {},
              child: GestureDetector(
                onTap: () {
                  context.read<AddIncomeExpenseBloc>().add(DeleteIncomeExpenseClickEvent(transactionId: index!.toInt()));
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.delete,
                  color: AppColors.secondaryColor,
                ),
              ),
            ),
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
}
