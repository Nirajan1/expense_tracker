import 'package:expense_tracker/features/auth/presentation/pages/sign_in_page.dart';
import 'package:expense_tracker/features/bottom_navigation/presentation/pages/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplacePageView extends StatefulWidget {
  const SplacePageView({super.key});

  @override
  State<SplacePageView> createState() => _SplacePageViewState();
}

class _SplacePageViewState extends State<SplacePageView> {
  @override
  void initState() {
    super.initState();
    splashLoader();
  }

  void splashLoader() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool isLoggedIn = prefs.getBool('loggedIn') ?? false;

    await Future.delayed(
      const Duration(seconds: 1),
      () {
        navigateToNextScreen(isLoggedIn);
      },
    );
  }

  void navigateToNextScreen(bool isLoggedIn) {
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => isLoggedIn ? BottomNavigationView() : const SignInPageView(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Expanse Tracker'),
            ],
          ),
        ),
      ),
    );
  }
}
