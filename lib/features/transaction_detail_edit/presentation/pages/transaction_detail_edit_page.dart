import 'package:expense_tracker/core/app_colors.dart';
import 'package:expense_tracker/core/app_top_container.dart';
import 'package:expense_tracker/features/add_transaction/domain_layer/entity/transaction_entity.dart';
import 'package:expense_tracker/features/add_transaction/presentation/bloc/add_income_expense_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TransactionDetailEditPageView extends StatefulWidget {
  final TransactionEntity transactionEntity;

  const TransactionDetailEditPageView({required this.transactionEntity, super.key});

  @override
  State<TransactionDetailEditPageView> createState() => _TransactionDetailEditPageViewState();
}

class _TransactionDetailEditPageViewState extends State<TransactionDetailEditPageView> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final GlobalKey<FormState> editKey = GlobalKey<FormState>();
  String? categoryFrom = '';
  String? categoryTo = '';
  String? transactionType = '';
  @override
  void dispose() {
    _amountController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_amountController.text.isEmpty) {
      _amountController.text = 'Rs ${widget.transactionEntity.amount}';
    }
    if (_dateController.text.isEmpty) {
      _dateController.text = widget.transactionEntity.date;
    }

    if (categoryFrom!.isEmpty || categoryTo!.isEmpty || transactionType!.isEmpty) {
      categoryFrom = widget.transactionEntity.categoryFrom;
      categoryTo = widget.transactionEntity.categoryTo;
      transactionType = widget.transactionEntity.type;
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: editKey,
          child: Column(
            children: [
              AppTopContainer(title: 'Edit Transaction'),
              const SizedBox(height: 18),
              _buildCategory(context, 'Type', transactionType.toString()),
              const SizedBox(height: 18),
              _buildDateField(context),
              const SizedBox(height: 18),
              _buildCategory(context, 'From', categoryFrom.toString()),
              const SizedBox(height: 18),
              _buildCategory(context, 'To', categoryTo.toString()),
              const SizedBox(height: 18),
              _buildInputField(context, 'Transaction Amount', _amountController),
              const SizedBox(height: 18),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 10.0),
        child: SizedBox(
          height: 52,
          child: BlocConsumer<AddIncomeExpenseBloc, AddIncomeExpenseState>(
            listener: (context, state) {
              if (state is TransactionSuccessState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Successfully Updated'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else if (state is TransactionErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            },
            builder: (context, state) {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                    maximumSize: Size(MediaQuery.of(context).size.width, 100),
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    )),
                onPressed: state is TransactionLoadingState
                    ? null
                    : () {
                        // Map data = {
                        //   'amount': _amountController.text,
                        //   'date': _dateController.text,
                        //   'categoryFrom': categoryFrom.toString(),
                        //   'categoryTo': categoryTo.toString(),
                        //   'type': _typeController.text,
                        // };
                        // print(widget.transactionEntity.id);
                        if (editKey.currentState!.validate()) {
                          context.read<AddIncomeExpenseBloc>().add(
                                UpdateIncomeExpenseClickEvent(
                                  transactionEntity: TransactionEntity(
                                    id: widget.transactionEntity.id,
                                    amount: _amountController.text.replaceAll('Rs', ''),
                                    date: _dateController.text,
                                    categoryFrom: categoryFrom.toString(),
                                    categoryTo: categoryTo.toString(),
                                    type: transactionType.toString(),
                                  ),
                                ),
                              );
                          _amountController.clear();
                          _dateController.clear();
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        }
                      },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    state is TransactionLoadingState?
                        ? SizedBox(
                            height: 14,
                            width: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ))
                        : const SizedBox.shrink(),
                    state is TransactionLoadingState ? SizedBox(width: 14) : const SizedBox.shrink(),
                    Text(
                      'Update',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: AppColors.whiteColor,
                          ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(BuildContext context, String title, TextEditingController controller) {
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
            controller: controller,
            keyboardType: title == 'Transaction Type' ? TextInputType.text : TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Enter ${title.toLowerCase()}',
              hintStyle: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Transaction Date',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: () async {
              final DateTime? pickedDate = await showDatePicker(
                context: context,
                firstDate: DateTime(1999),
                lastDate: DateTime(33003),
              );
              if (pickedDate != null) {
                final String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                _dateController.text = formattedDate;
              }
            },
            child: AbsorbPointer(
              child: TextFormField(
                controller: _dateController,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.date_range_outlined,
                    color: AppColors.primaryColor,
                  ),
                  hintText: 'Pick a transaction date',
                  hintStyle: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
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
            title == 'Type' ? 'Transaction $title' : 'Transaction Category $title',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 14),
          ButtonTheme(
            alignedDropdown: true,
            child: DropdownButtonFormField(
              value: selectedValue,
              style: Theme.of(context).textTheme.labelLarge,
              dropdownColor: AppColors.whiteColor,
              hint: Text('Select a category'),
              items: title == 'Type'
                  ? [
                      DropdownMenuItem(value: 'income', child: Text('Income')),
                      DropdownMenuItem(value: 'expense', child: Text('Expense')),
                    ]
                  : [
                      DropdownMenuItem(value: 'Person', child: Text('Person')),
                      DropdownMenuItem(value: 'Cash', child: Text('Cash')),
                      DropdownMenuItem(value: 'Income', child: Text('Income')),
                      DropdownMenuItem(value: 'Expense', child: Text('Expense')),
                      DropdownMenuItem(value: 'Bank', child: Text('Bank')),
                      DropdownMenuItem(value: 'Opening Balance', child: Text('Opening Balance')),
                    ],
              onChanged: (value) {
                if (title == "From") {
                  categoryFrom = value;
                } else if (title == "To") {
                  categoryTo = value;
                } else if (title == "Type") {
                  transactionType = value;
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
