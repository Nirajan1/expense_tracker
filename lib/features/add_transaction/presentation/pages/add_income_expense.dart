import 'package:expense_tracker/core/app_colors.dart';
import 'package:expense_tracker/core/app_snack_bar.dart';
import 'package:expense_tracker/features/add_transaction/domain_layer/entity/transaction_entity.dart';
import 'package:expense_tracker/features/add_transaction/presentation/bloc/add_income_expense_bloc.dart';
import 'package:expense_tracker/features/ledger/presentation_layer/bloc/ledger_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AddIncomeExpensePageView extends StatefulWidget {
  final String title;
  const AddIncomeExpensePageView({required this.title, super.key});

  @override
  State<AddIncomeExpensePageView> createState() => _AddIncomeExpensePageViewState();
}

class _AddIncomeExpensePageViewState extends State<AddIncomeExpensePageView> {
  final TextEditingController _transactionAmountController = TextEditingController();
  final TextEditingController _transactionDateController = TextEditingController();
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  String? ledgerFrom = '';
  String? ledgerTo = '';
  @override
  void dispose() {
    _transactionAmountController.dispose();
    _transactionDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopContainer(context),
              const SizedBox(height: 18),
              _buildInputField(context, 'Transaction Amount'),
              const SizedBox(height: 18),
              _buildDateField(context),
              const SizedBox(height: 18),
              _buildCategory(context, widget.title == "Expense" ? "To" : 'From', widget.title == "Expense" ? ledgerTo.toString() : ledgerFrom.toString()),
              const SizedBox(height: 18),
              _buildCategory(context, widget.title == "Expense" ? "From" : 'To', widget.title == "Expense" ? ledgerFrom.toString() : ledgerTo.toString()),
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
                // ScaffoldMessenger.of(context).showSnackBar(
                //   SnackBar(
                //     content: Text('Successfully added'),
                //     backgroundColor: Colors.green,
                //   ),
                // );
                AppSnackBar.showCustomSnackBar(context, 'Successfully added', false, isTop: true);
              } else if (state is TransactionErrorState) {
                AppSnackBar.showCustomSnackBar(context, state.error, true, isTop: true);
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
                        Map data = {
                          'amount': _transactionAmountController.text,
                          'date': _transactionDateController.text,
                          'ledgerFrom': ledgerFrom.toString(),
                          'ledgerTo': ledgerTo.toString(),
                          'type': widget.title.toLowerCase(),
                        };
                        print(data);
                        if (key.currentState!.validate()) {
                          context.read<AddIncomeExpenseBloc>().add(
                                AddIncomeExpenseClickEvent(
                                  transactionEntity: TransactionEntity(
                                    id: null,
                                    amount: _transactionAmountController.text,
                                    date: _transactionDateController.text,
                                    ledgerFrom: ledgerFrom.toString(),
                                    ledgerTo: ledgerTo.toString(),
                                    type: widget.title.toLowerCase(),
                                  ),
                                ),
                              );
                          _transactionAmountController.clear();
                          _transactionDateController.clear();
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
                      'Add',
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
                  'Add ${widget.title}',
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

  Widget _buildInputField(BuildContext context, String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _transactionAmountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Enter a transaction amount',
              hintStyle: Theme.of(context).textTheme.bodyMedium,
            ),
            validator: (value) => value == null || value.isEmpty ? '$name is required' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildDateField(BuildContext context) {
    _transactionDateController.text = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
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
                lastDate: DateTime(3300),
              );

              if (pickedDate != null) {
                final TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );

                if (pickedTime != null) {
                  final DateTime combinedDateTime = DateTime(
                    pickedDate.year,
                    pickedDate.month,
                    pickedDate.day,
                    pickedTime.hour,
                    pickedTime.minute,
                  );

                  final String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm').format(combinedDateTime);
                  _transactionDateController.text = formattedDateTime;
                }
              }
            },
            child: AbsorbPointer(
              child: TextFormField(
                controller: _transactionDateController,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.date_range_outlined,
                    color: AppColors.primaryColor,
                  ),
                  hintText: 'Pick a transaction date',
                  hintStyle: Theme.of(context).textTheme.bodyMedium,
                ),
                validator: (value) => value == null || value.isEmpty ? 'date time is required' : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategory(BuildContext context, String name, String selectedValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ledger $name',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 14),
          BlocBuilder<LedgerBloc, LedgerState>(
            builder: (context, state) {
              if (state is LedgerLoadingState) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is LedgerLoadedState) {
                return ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButtonFormField(
                    style: Theme.of(context).textTheme.labelLarge,
                    dropdownColor: AppColors.whiteColor,
                    hint: Text('Select a category'),
                    validator: (value) => value == null ? 'Ledger is required' : null,
                    items: state.ledgerList.isNotEmpty
                        ? state.ledgerList
                            .where(
                            (element) => (widget.title == 'Income' && name == 'From')
                                ? element.categoryType != 'OpeningBalance' && element.categoryType != 'Cash' && element.categoryType != 'Expense'
                                : (widget.title == 'Income' && name == 'To')
                                    ? element.categoryType != 'OpeningBalance' && element.categoryType != 'Person' && element.categoryType != 'Expense' && element.categoryType != 'Income'
                                    : (widget.title == 'Expense' && name == 'To')
                                        ? element.categoryType != 'OpeningBalance' && element.categoryType != 'Cash' && element.categoryType != 'Income'
                                        : (widget.title == 'Expense' && name == 'From')
                                            ? element.categoryType != 'OpeningBalance' && element.categoryType != 'Person' && element.categoryType != 'Expense' && element.categoryType != 'Income'
                                            : element.categoryType != 'Cash',
                          )
                            .map((ledger) {
                            return DropdownMenuItem(
                              value: ledger.name,
                              child: Row(
                                children: [
                                  Text(ledger.name),
                                  // const SizedBox(width: 8),
                                  // Text('Type: ${ledger.categoryType}'),
                                ],
                              ),
                            );
                          }).toList()
                        : [
                            const DropdownMenuItem(
                              value: null,
                              child: Text('No Ledger available'),
                            )
                          ],
                    onChanged: (value) {
                      if (state.ledgerList.isNotEmpty) {
                        if (name == "From") {
                          ledgerFrom = value.toString();
                        } else {
                          ledgerTo = value.toString();
                        }
                      }
                    },
                  ),
                );
              } else {
                return Text('No data found');
              }
            },
          ),
        ],
      ),
    );
  }
}
