import 'package:expense_tracker/core/app_colors.dart';
import 'package:expense_tracker/features/add_transaction/domain_layer/entity/transaction_entity.dart';
import 'package:expense_tracker/features/add_transaction/presentation/bloc/add_income_expense_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SecondaryTabBar extends StatefulWidget {
  final double radius;

  const SecondaryTabBar({required this.radius, super.key});

  @override
  State<SecondaryTabBar> createState() => _SecondaryTabBarState();
}

class _SecondaryTabBarState extends State<SecondaryTabBar> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 45,
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              color: Colors.grey,
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(widget.radius),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.radius),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = 0;
                        _pageController.animateToPage(0, duration: const Duration(milliseconds: 300), curve: Curves.ease); // Animate to page 0
                      });
                    },
                    child: Container(
                      color: _selectedIndex == 0 ? Colors.green : Colors.transparent,
                      child: Center(
                        // Added const here
                        child: Text(
                          'Income',
                          style: TextStyle(
                            color: _selectedIndex == 0 ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = 1;
                        _pageController.animateToPage(1, duration: const Duration(milliseconds: 300), curve: Curves.ease); // Animate to page 1
                      });
                    },
                    child: Container(
                      color: _selectedIndex == 1 ? Colors.redAccent : Colors.transparent,
                      child: Center(
                        child: Text(
                          'Expense',
                          style: TextStyle(
                            color: _selectedIndex == 1 ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(), // Keep this if you don't want user scrolling
            itemCount: 2, // Corrected itemCount to 2
            itemBuilder: (context, index) {
              return _buildPage(index);
            },
          ),
        ),
      ],
    );
  }
}

Widget _buildPage(int index) {
  switch (index) {
    case 0:
      return const PageContent(
        // Added const here
        title: 'Income', // Corrected title
        color: Colors.green, // Corrected color
        content: 'Income Content Here',
      );
    case 1:
      return const PageContent(
        // Added const here
        title: 'Expense', // Corrected title
        color: Colors.redAccent, // Corrected color
        content: 'Expense Content Here',
      );
    default:
      return Container();
  }
}

class PageContent extends StatelessWidget {
  final String title;
  final Color? color;
  final String content;

  const PageContent({super.key, required this.title, this.color, required this.content});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // color: color,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 22),
            _buildCircularContainer(context, title, color),
            const SizedBox(height: 12),
            Expanded(
              child: _buildDatList(context, title, color),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildCircularContainer(BuildContext context, String title, Color? color) {
  return Container(
    width: 200,
    height: 200,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: color,
    ),
    child: Center(
      child: Container(
        width: 180,
        height: 180,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: Center(
          child: Container(
            width: 162,
            height: 162,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black54,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Total $title',
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: Colors.white,
                        ),
                  ),
                  BlocBuilder<AddIncomeExpenseBloc, AddIncomeExpenseState>(
                    builder: (context, state) {
                      int total = 0;
                      if (state is TransactionLoadingState) {
                        return CircularProgressIndicator();
                      } else if (state is TransactionLoaded) {
                        if (state.transactionsEntity.isEmpty) {
                          total = 0;
                        } else if (state.transactionsEntity.isNotEmpty) {
                          total =
                              state.transactionsEntity.where((element) => element.type[0].toUpperCase() + element.type.substring(1) == title).fold<int>(0, (sum, item) => sum + int.parse(item.amount));
                        }
                      }
                      return Text(
                        total.toString(),
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              color: Colors.white,
                            ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Widget _buildDatList(BuildContext context, String title, Color? color) {
  return BlocBuilder<AddIncomeExpenseBloc, AddIncomeExpenseState>(
    builder: (context, state) {
      if (state is TransactionLoadingState) {
        return CircularProgressIndicator();
      } else if (state is TransactionLoaded) {
        // Filter the transactions based on the selected type
        List<TransactionEntity> filteredTransactions = state.transactionsEntity.where((element) => element.type[0].toUpperCase() + element.type.substring(1) == title).toList();

        // state.transactionsEntity.where((transaction) {
        // if (title == 'Income') {
        //   return transaction.type.toLowerCase() == 'income';
        // } else if (title == 'Expense') {
        //   return transaction.type.toLowerCase() == 'expense';
        // }
        // return false;

        // }).toList();

        if (filteredTransactions.isEmpty) {
          return const Center(
            child: Text(
              'No transactions available',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          );
        }
        // print(filteredTransactions);
        return ListView.builder(
          itemCount: filteredTransactions.length,
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            // print(data);
            return _card(context, title, color, filteredTransactions[index], index);
          },
        );
      } else if (state is TransactionErrorState) {
        return Text('Error loading transactions');
      } else {
        return Text('No transactions found');
      }
    },
  );
}

Widget _card(BuildContext context, String title, Color? color, TransactionEntity transactionEntity, int index) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 12, horizontal: 18),
    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
    decoration: BoxDecoration(
      color: AppColors.whiteColor,
      borderRadius: BorderRadius.circular(10),
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
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            title == 'Income' ? Icons.add : Icons.remove,
            color: color,
            size: 10,
          ),
          Text(
            'Rs ${transactionEntity.amount}',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 18,
              color: color,
            ),
          ),
        ],
      ),
      title: Text(title),
      subtitle: Text(
        transactionEntity.date,
        style: TextStyle(
          fontSize: 12,
        ),
      ),
    ),
  );
}
