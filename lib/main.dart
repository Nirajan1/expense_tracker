import 'package:expense_tracker/core/app_theme.dart';
import 'package:expense_tracker/features/add_transaction/presentation/bloc/add_income_expense_bloc.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:expense_tracker/features/bottom_navigation/bloc/navigation_bloc.dart';
import 'package:expense_tracker/features/bottom_navigation/presentation/pages/bottom_navigation.dart';
import 'package:expense_tracker/features/category/presentation/bloc/category_bloc.dart';
import 'package:expense_tracker/features/ledger/presentation_layer/bloc/ledger_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/core/di.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color(0xFF003366), // Set status bar color
      systemNavigationBarColor: Color(0xFF003366), // Set status bar color
      statusBarIconBrightness: Brightness.light, // For dark icons (Android)
      statusBarBrightness: Brightness.dark, // For iOS (dark text/icons)
    ),
  );
  await di.init();
  // final SharedPreferences prefs = await SharedPreferences.getInstance();
  // final bool isLoggedIn = prefs.getBool('loggedIn') ?? false;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // final bool isLoggedIn;
  const MyApp({
    super.key,
    // required this.isLoggedIn,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => di.sl<NavigationBloc>()),
        BlocProvider(create: (context) => di.sl<AddIncomeExpenseBloc>()),
        BlocProvider(create: (context) => di.sl<CategoryBloc>()),
        BlocProvider(create: (context) => di.sl<LedgerBloc>()),
        BlocProvider(create: (context) => di.sl<AuthBloc>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Expense tracker',
        theme: AppTheme.lightTheme,
        home: BottomNavigationView(),
        // home: isLoggedIn ? BottomNavigationView() : const SignInPageView(),
      ),
    );
  }
}
