import 'package:expense_tracker/core/app_colors.dart';
import 'package:expense_tracker/core/app_snack_bar.dart';
import 'package:expense_tracker/features/add_transaction/presentation/pages/add_transaction_page.dart';
import 'package:expense_tracker/features/bottom_navigation/bloc/navigation_bloc.dart';
import 'package:expense_tracker/features/home/presentation/home_page.dart';
import 'package:expense_tracker/features/profile/presentation/pages/profile_page.dart';
import 'package:expense_tracker/features/report/presentation/pages/report_page.dart';
import 'package:expense_tracker/features/transaction/presentation/pages/transaction_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomNavigationView extends StatefulWidget {
  const BottomNavigationView({super.key});

  @override
  State<BottomNavigationView> createState() => _BottomNavigationViewState();
}

class _BottomNavigationViewState extends State<BottomNavigationView> {
  DateTime? _lastBackButtonPressTime;

  void showSnacBar() {
    AppSnackBar.showCustomSnackBar(context, 'Press back again to exit', false, isTop: false);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        int currentIndex = 0;
        if (state is ButtonTapState) {
          currentIndex = state.tappedIndex;
        }
        return Scaffold(
          bottomNavigationBar: Stack(
            clipBehavior: Clip.none,
            children: [
              _buildBottomNavigation(context, currentIndex),
              Positioned(
                top: -31,
                right: MediaQuery.of(context).size.width * 0.43,
                child: InkWell(
                  onTap: () {
                    context.read<NavigationBloc>().add(ButtonTapEvent(tappedIndex: 2));
                  },
                  child: Container(
                    height: 60,
                    width: 58,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryColor,
                    ),
                    child: Icon(
                      Icons.add,
                      color: AppColors.whiteColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) return;
              final now = DateTime.now();
              final lastPress = _lastBackButtonPressTime;
              // Check if the user pressed back within 2 seconds
              if (lastPress == null || now.difference(lastPress) > Duration(seconds: 2)) {
                // Update the last back button press time
                _lastBackButtonPressTime = now;

                // Show a SnackBar
                showSnacBar();
              } else {
                // Exit the app if the user pressed back again within 2 seconds
                Navigator.of(context).pop();
              }
            },
            child: _buildBody(context, currentIndex),
          ),
        );
      },
    );
  }
}

Widget _buildBody(BuildContext context, index) {
  List pages = [
    HomePageView(), // index 0
    TransactionPageView(), // index 1
    AddTransactionPageView(), // index 2 FAB
    ReportPageView(), // index 3
    ProfilePageView(), // index 4
  ];
  return pages[index];
}

Widget _buildBottomNavigation(BuildContext context, int currentIndex) {
  return Stack(
    children: [
      BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.primaryColor,
        landscapeLayout: BottomNavigationBarLandscapeLayout.linear,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        currentIndex: currentIndex > 2 ? currentIndex - 1 : currentIndex, // Adjusted logic
        onTap: (index) {
          if (index == 2) {
            context.read<NavigationBloc>().add(ButtonTapEvent(tappedIndex: 3));
          } else {
            int adjustedIndex = index > 2 ? index + 1 : index;
            context.read<NavigationBloc>().add(ButtonTapEvent(tappedIndex: adjustedIndex));
          }
        },
        selectedIconTheme: IconThemeData(
          color: AppColors.secondaryColor,
        ),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(right: 42),
              child: Icon(Icons.date_range),
            ),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(left: 42.0),
              child: Icon(Icons.card_giftcard),
            ),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      Positioned(
        top: -36,
        right: MediaQuery.of(context).size.width * 0.416,
        child: Container(
          height: 68,
          width: 69,
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            shape: BoxShape.circle,
          ),
        ),
      ),
    ],
  );
}
