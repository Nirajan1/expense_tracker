import 'package:expense_tracker/core/app_colors.dart';
import 'package:expense_tracker/core/app_top_container.dart';
import 'package:expense_tracker/features/category/presentation/bloc/category_bloc.dart';
import 'package:expense_tracker/features/ledger/domain_layer/entity/ledger_entity.dart';
import 'package:expense_tracker/features/ledger/presentation_layer/bloc/ledger_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddLedgerPageView extends StatefulWidget {
  const AddLedgerPageView({super.key});

  @override
  State<AddLedgerPageView> createState() => _AddLedgerPageViewState();
}

class _AddLedgerPageViewState extends State<AddLedgerPageView> {
  final TextEditingController _ledgerNameController = TextEditingController();
  final TextEditingController _openingBalanceController = TextEditingController();
  String selectedValue = '';
  final String openingBalanceValue = 'Cr';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    _ledgerNameController.dispose();
    _openingBalanceController.dispose();
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
              AppTopContainer(title: 'Add Ledger'),
              _buildInputField(context, 'Ledger Name'),
              _buildCategory(context, 'Group', selectedValue),
              _buildOpeningStock(context),
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
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Successfully added'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else if (state is LegerErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
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
                        // Map data = {
                        //   'amount': _transactionAmountController.text,
                        //   'date': _transactionDateController.text,
                        //   'categoryFrom': categoryFrom.toString(),
                        //   'categoryTo': categoryTo.toString(),
                        //   'type': widget.title.toLowerCase(),
                        // };
                        // print(data);
                        if (_formKey.currentState!.validate()) {
                          context.read<LedgerBloc>().add(
                                LedgerAddClickEvent(
                                    ledgerEntity: LedgerEntity(
                                  id: 0,
                                  name: _ledgerNameController.text,
                                  categoryType: selectedValue,
                                  openingBalance: _openingBalanceController.text as int,
                                  openingBalanceType: openingBalanceValue,
                                )),
                              );

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
            keyboardType: TextInputType.number,
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

  Widget _buildCategory(BuildContext context, String title, String selectedValue) {
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
                    value: selectedValue.isNotEmpty ? selectedValue : null,
                    validator: (value) => value == null || value.isEmpty ? 'group is required' : null,
                    items: state.categoryEntity
                        .map(
                          (category) => DropdownMenuItem<String>(
                            value: category.name,
                            child: Text(category.name),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      selectedValue = value!;
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
    );
  }

  Widget _buildOpeningStock(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Opening Stock',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 14),
        DrCrDropDownWidget(
          controller: _openingBalanceController,
          value: openingBalanceValue,
        ),
        // TextFormField(
        //   keyboardType: TextInputType.number,
        //   decoration: InputDecoration(
        //     hintText: 'Enter opening stock',
        //     hintStyle: Theme.of(context).textTheme.bodyMedium,
        //   ),
        //   validator: (value) => value == null || value.isEmpty ? 'Opening stock is required' : null,
        // ),
      ],
    );
  }
}

class DrCrDropDownWidget extends StatelessWidget {
  final TextEditingController controller;
  final String value;
  const DrCrDropDownWidget({
    required this.controller,
    required this.value,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.9 - MediaQuery.of(context).size.width * 0.7,
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
                value: value.toString(),
                dropdownColor: AppColors.whiteColor,
                isExpanded: true,
                items: const [
                  DropdownMenuItem(value: 'Cr', child: Text('Cr')),
                  DropdownMenuItem(value: 'Dr', child: Text('Dr')),
                ],
                onChanged: (newValue) {},
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                style: Theme.of(context).textTheme.labelLarge, // Text style for the dropdown items.
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: TextFormField(),
            ),
          ),
        ],
      ),
    );
  }
}
