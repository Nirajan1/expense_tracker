import 'dart:io';

import 'package:expense_tracker/core/app_card_layout.dart';
import 'package:expense_tracker/core/app_colors.dart';
import 'package:expense_tracker/features/add_transaction/presentation/bloc/add_income_expense_bloc.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:expense_tracker/features/bottom_navigation/bloc/navigation_bloc.dart';
import 'package:expense_tracker/features/category/presentation/bloc/category_bloc.dart';
import 'package:expense_tracker/features/home/presentation/all_data.dart';
import 'package:expense_tracker/features/ledger/presentation_layer/bloc/ledger_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:objectbox/objectbox.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  @override
  void initState() {
    super.initState();
    //Ensures that getData() is called after the first frame is built, avoiding unnecessary re-renders or context issues.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
    });
  }

  Future<void> getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userName = preferences.getString('userName');
    await Future.delayed(const Duration(microseconds: 777777));

    if (mounted) {
      context.read<AddIncomeExpenseBloc>().add(IncomeExpenseLoadEvent());
      context.read<CategoryBloc>().add(GetAllCategoryClickEvent());
      context.read<AuthBloc>().add(GetUserBynameClickEvent(userName: userName.toString()));
      context.read<LedgerBloc>().add(GetAllLedgersClickEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _topContainer(context),
        SizedBox(height: MediaQuery.of(context).size.height * 0.036),
        _buildBudgetCard(context),
        SizedBox(height: Platform.isAndroid ? MediaQuery.of(context).size.height * 0.05 : MediaQuery.of(context).size.height * 0.036),
        Expanded(child: _bottomContainer(context)),
      ],
    );
  }
}

Widget _topContainer(BuildContext context) {
  final double heightFactor = MediaQuery.of(context).size.height * 0.18;
  final double padding = 18.0;

  return Container(
    width: MediaQuery.of(context).size.width,
    height: heightFactor,
    color: AppColors.primaryColor,
    child: Column(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.1),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: padding),
              child: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  String userName = 'Demo User';
                  if (state is GetUserBynameClickLoadingState) {
                    userName = 'Demo User';
                  } else if (state is GetUserByNameLoadedState) {
                    userName = state.signUpEntity?.userName ?? 'Demo User';
                  }
                  return Row(
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: AppColors.whiteColor,
                        child: Text(userName[0].toUpperCase()),
                      ),
                      SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Hi, $userName', style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: AppColors.whiteColor)),
                          Text('Good morning', style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: AppColors.whiteColor)),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
            BlocListener<NavigationBloc, NavigationState>(
              listener: (context, state) {},
              child: GestureDetector(
                onTap: () {
                  context.read<NavigationBloc>().add(ButtonTapEvent(tappedIndex: 4));
                },
                child: Padding(
                  padding: EdgeInsets.only(right: padding),
                  child: Container(
                    height: 42,
                    width: 36,
                    decoration: BoxDecoration(color: AppColors.whiteColor, shape: BoxShape.circle),
                    child: Icon(Icons.person_outline, color: AppColors.primaryColor),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
      ],
    ),
  );
}

Widget _buildBudgetCard(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 18.0),
    child: Row(
      spacing: 10,
      children: [
        Expanded(
          child: CustomCardWidget(
            height: 176,
            child: BlocBuilder<LedgerBloc, LedgerState>(
              builder: (context, state) {
                double cashClosing = 0;
                double bankClosing = 0;
                if (state is LedgerLoadingState) {
                  // Show 0 or a loading indicator while data is being fetched
                  cashClosing = 0.0;
                } else if (state is LedgerLoadedState) {
                  if (state.ledgerList.isNotEmpty) {
                    for (var data in state.ledgerList) {
                      if (data.categoryType == 'Cash') {
                        try {
                          // Parse the closingBalance and add it to the total
                          cashClosing += double.parse(data.closingBalance);
                        } catch (e) {
                          // Handle parsing errors (e.g., if closingBalance is not a valid number)
                          debugPrint('Error parsing closingBalance: ${data.closingBalance}');
                        }
                      } else {
                        cashClosing = 0.0;
                      }
                    }
                    for (var data in state.ledgerList) {
                      if (data.categoryType == 'Bank') {
                        try {
                          // Parse the closingBalance and add it to the total
                          bankClosing += double.parse(data.closingBalance);
                        } catch (e) {
                          // Handle parsing errors (e.g., if closingBalance is not a valid number)
                          debugPrint('Error parsing closingBalance: ${data.closingBalance}');
                        }
                      } else {
                        bankClosing = 0.0;
                      }
                    }
                  }
                }

                return Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 20,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.money),
                          const SizedBox(width: 3),
                          Text('Cash : '),
                          Text(
                            'Rs ${cashClosing.toInt()}',
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.account_balance),
                          const SizedBox(width: 3),
                          Text('Cash : '),
                          Text(
                            'Rs ${bankClosing.toInt()}',
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        Expanded(
          child: Column(
            spacing: 18,
            children: [
              CustomCardWidget(
                height: 80,
                color: Colors.green,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Income',
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    BlocBuilder<AddIncomeExpenseBloc, AddIncomeExpenseState>(
                      builder: (context, state) {
                        int total = 0;
                        if (state is TransactionLoadingState) {
                          total = 0;
                        } else if (state is TransactionLoaded) {
                          if (state.transactionsEntity.isEmpty) {
                            total = 0;
                          } else if (state.transactionsEntity.isNotEmpty) {
                            total = state.transactionsEntity.where((element) => element.type == 'income').fold<int>(0, (sum, item) => sum + int.parse(item.amount));
                          }
                        }
                        return Text(
                          'Rs $total',
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleSmall!.copyWith(color: AppColors.whiteColor),
                        );
                      },
                    ),
                  ],
                ),
              ),
              CustomCardWidget(
                height: 80,
                width: MediaQuery.of(context).size.width,
                color: Colors.redAccent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Expense',
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              color: AppColors.whiteColor,
                              fontWeight: FontWeight.w500,
                            )),
                    BlocBuilder<AddIncomeExpenseBloc, AddIncomeExpenseState>(
                      builder: (context, state) {
                        int total = 0;
                        if (state is TransactionLoadingState) {
                          total = 0;
                        } else if (state is TransactionLoaded) {
                          if (state.transactionsEntity.isEmpty) {
                            total = 0;
                          } else if (state.transactionsEntity.isNotEmpty) {
                            total = state.transactionsEntity.where((element) => element.type == 'expense').fold<int>(0, (sum, item) => sum + int.parse(item.amount));
                          }
                        }
                        return Text(
                          'Rs $total',
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleSmall!.copyWith(color: AppColors.whiteColor),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );
}

Widget _bottomContainer(BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width,
    padding: EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: AppColors.whiteColor,
      borderRadius: BorderRadius.only(topLeft: Radius.circular(40.0), topRight: Radius.circular(40.0)),
      boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.5), spreadRadius: 6, blurRadius: 6, offset: Offset(0, 1))],
      border: Border(top: BorderSide(color: Colors.grey.shade300)),
    ),
    child: Column(
      children: [
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 17.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // const SizedBox(width: 1),
              Text('Recent Transaction', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold)),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AllDataPageView()));
                },
                child: Text('See More', style: Theme.of(context).textTheme.titleSmall!.copyWith(color: AppColors.primaryColor, fontWeight: FontWeight.bold)),
              ),
              // const SizedBox(width: 1),
            ],
          ),
        ),
        const SizedBox(height: 22),
        BlocBuilder<AddIncomeExpenseBloc, AddIncomeExpenseState>(
          builder: (context, state) {
            if (state is TransactionLoadingState) {
              return CircularProgressIndicator();
            } else if (state is TransactionLoaded) {
              if (state.transactionsEntity.isEmpty) {
                return Padding(padding: const EdgeInsets.only(top: 60), child: Text('No transactions available', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)));
              }
              int itemCount = state.transactionsEntity.length;
              if (Platform.isAndroid && itemCount >= 3) {
                itemCount = 3;
              } else if (Platform.isIOS && itemCount >= 3) {
                itemCount = 3;
              }
              return ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: itemCount,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return _buildCard(
                    title: state.transactionsEntity[index].type[0].toUpperCase() + state.transactionsEntity[index].type.substring(1),
                    price: state.transactionsEntity[index].amount,
                    date: state.transactionsEntity[index].date,
                  );
                },
              );
            } else if (state is TransactionErrorState) {
              return Text('Error loading transactions');
            } else {
              return Text('No transactions found');
            }
          },
        ),
      ],
    ),
  );
}

Widget _buildCard({required String title, required String price, required String date}) {
  return AppCardLayoutView(
    child: ListTile(
      shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(10)),
      leading: Container(width: 50, height: 50, decoration: BoxDecoration(color: title == 'Expense' ? Colors.redAccent : Colors.green, shape: BoxShape.circle)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 4,
        children: [
          Icon(title == 'Expense' ? Icons.arrow_downward : Icons.arrow_upward, color: title == 'Expense' ? Colors.redAccent : Colors.green, size: 16),
          Text('Rs $price', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18, color: title == 'Expense' ? Colors.redAccent : Colors.green)),
        ],
      ),
      title: Text(title),
      subtitle: Text(date, style: TextStyle(fontSize: 12)),
    ),
  );
}

class CustomCardWidget extends StatelessWidget {
  final Widget child;
  final double height;
  final double? width;
  final Color? color;
  const CustomCardWidget({
    required this.height,
    this.width,
    required this.child,
    this.color = AppColors.whiteColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10), topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        // gradient: LinearGradient(
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        //   colors: [
        //     Colors.green,
        //     Colors.redAccent,
        //     Colors.amber,
        //   ],
        // ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(-3, 6), // changes position of shadow
          ),
        ],
        border: Border(top: BorderSide(color: Colors.grey.shade300), bottom: BorderSide(color: Colors.grey.shade300), left: BorderSide(color: Colors.grey.shade300)),
      ),
      child: child,
    );
  }
}
