import 'package:expense_tracker/core/app_colors.dart';
import 'package:expense_tracker/core/app_snack_bar.dart';
import 'package:expense_tracker/core/app_top_container.dart';
import 'package:expense_tracker/features/category/presentation/bloc/category_bloc.dart';
import 'package:expense_tracker/features/ledger/domain_layer/entity/ledger_entity.dart';
import 'package:expense_tracker/features/ledger/presentation_layer/bloc/ledger_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateLedgerPageView extends StatefulWidget {
  final String ledgerName;
  final String openingBalanceAmount;
  final String openingBalanceValue;
  final int ledegerId;
  final String selectedCategoryType;
 final String closingBalance;
  const UpdateLedgerPageView({
    required this.ledgerName,
    required this.openingBalanceAmount,
    required this.openingBalanceValue,
    required this.ledegerId,
    required this.selectedCategoryType,
    required this.closingBalance,
    super.key,
  });

  @override
  State<UpdateLedgerPageView> createState() => _UpdateLedgerPageViewState();
}

class _UpdateLedgerPageViewState extends State<UpdateLedgerPageView> {
  final TextEditingController _ledgerNameController = TextEditingController();
  // final TextEditingController _openingBalanceController = TextEditingController();
  final TextEditingController _openingBalanceAmountController = TextEditingController(text: '0');
  String? selectedValue = '';
  String openingBalanceValue = 'Dr';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _ledgerNameController.text = widget.ledgerName;
    _openingBalanceAmountController.text = widget.openingBalanceAmount.toString();
    openingBalanceValue = widget.openingBalanceValue;
    selectedValue = widget.selectedCategoryType;
  }

  @override
  void dispose() {
    _ledgerNameController.dispose();
    // _openingBalanceController.dispose();
    _openingBalanceAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            spacing: 18,
            children: [
              AppTopContainer(title: 'Update Ledger'),
              _buildInputField(context, 'Ledger Name'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Group',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 14),
                    BlocBuilder<CategoryBloc, CategoryState>(
                      builder: (context, state) {
                        if (state is CategoryLoadedState) {
                          if (state.categoryEntity.isEmpty) {
                            return const Text("No categories available");
                          }
                          return ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButtonFormField<String>(
                              style: Theme.of(context).textTheme.labelLarge,
                              dropdownColor: AppColors.whiteColor,
                              hint: const Text('Select a category'),
                              value: selectedValue!.isNotEmpty ? selectedValue : null,
                              validator: (value) => value == null || value.isEmpty ? 'group is required' : null,
                              items: state.categoryEntity
                                  .map(
                                    (category) => DropdownMenuItem<String>(
                                      value: category.name,
                                      child: Text(category.name),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  selectedValue = value.toString();
                                });
                                print(selectedValue);
                              },
                            ),
                          );
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                  ],
                ),
              ),
              _buildOpeningBalance(context),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 10.0),
        child: SizedBox(
          height: 52,
          child: BlocConsumer<LedgerBloc, LedgerState>(
            listener: (context, state) {
              if (state is LedgerLoadedSuccessState) {
                AppSnackBar.showCustomSnackBar(context, 'Ledger added successfully!', false, isTop: true);
              } else if (state is LegerErrorState) {
                AppSnackBar.showCustomSnackBar(context, state.error, false, isTop: true);
              }
            },
            builder: (context, state) {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                    maximumSize: Size(MediaQuery.of(context).size.width, 100),
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    )),
                onPressed: state is LedgerLoadingState
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) {
                          final categoryEntity = (context.read<CategoryBloc>().state as CategoryLoadedState).categoryEntity;
                          final selectedCategory = categoryEntity.firstWhere(
                            (category) => category.name == selectedValue,
                          );
                          print(widget.ledegerId);
                          // Create the LedgerEntity to pass to LedgerBloc
                          final newLedger = LedgerEntity(
                            id: widget.ledegerId,
                            name: _ledgerNameController.text,
                            categoryType: selectedCategory.name,
                            openingBalance: int.parse(_openingBalanceAmountController.text),
                            openingBalanceType: openingBalanceValue,
                            closingBalance: widget.closingBalance,
                          );

                          // Add the ledger to the ledger bloc
                          context.read<LedgerBloc>().add(
                                LedgerUpdateClickEvent(ledgerEntity: newLedger),
                              );

                          _ledgerNameController.clear();
                          _openingBalanceAmountController.clear();
                          Navigator.of(context).pop();
                        }
                      },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    state is LedgerLoadingState?
                        ? SizedBox(
                            height: 14,
                            width: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ))
                        : const SizedBox.shrink(),
                    state is LedgerLoadingState ? SizedBox(width: 14) : const SizedBox.shrink(),
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

  Widget _buildInputField(BuildContext context, String title) {
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
            controller: _ledgerNameController,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              hintText: 'Enter a Ledger name',
              hintStyle: Theme.of(context).textTheme.bodyMedium,
            ),
            validator: (value) => value == null || value.isEmpty ? '$title is required' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildOpeningBalance(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Opening Balance',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _openingBalanceAmountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              prefixIcon: Container(
                width: MediaQuery.of(context).size.width * 0.2,
                margin: EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  border: Border.all(
                    width: 0.5,
                    color: Colors.transparent,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    topLeft: Radius.circular(10),
                  ),
                ),
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton<String>(
                    value: openingBalanceValue.toString(),
                    dropdownColor: AppColors.whiteColor,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(value: 'Cr', child: Text('+')),
                      DropdownMenuItem(value: 'Dr', child: Text('-')),
                    ],
                    onChanged: (newValue) {
                      setState(() {
                        openingBalanceValue = newValue!;
                      });
                    },
                    alignment: Alignment.bottomCenter,
                    // padding: const EdgeInsets.symmetric(horizontal: 8),
                    style: Theme.of(context).textTheme.labelLarge, // Text style for the dropdown items.
                  ),
                ),
              ),
              hintText: '',
              hintStyle: Theme.of(context).textTheme.bodyMedium,
            ),
            validator: (value) => value == null || value.isEmpty ? 'Opening balance is required' : null,
          ),
        ],
      ),
    );
  }
}

// class DrCrDropDownWidget extends StatelessWidget {
//   final TextEditingController controller;
//   final String value;
//   const DrCrDropDownWidget({
//     required this.controller,
//     required this.value,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return

//   }
// }
