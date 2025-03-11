import 'package:expense_tracker/core/app_colors.dart';
import 'package:expense_tracker/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:expense_tracker/features/auth/presentation/pages/sign_in_page.dart';
import 'package:expense_tracker/features/category/presentation/pages/category_list_page.dart';
import 'package:expense_tracker/features/ledger/presentation_layer/bloc/ledger_bloc.dart';
import 'package:expense_tracker/features/ledger/presentation_layer/pages/ledger_list_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePageView extends StatelessWidget {
  const ProfilePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      // spacing: 16,
      children: [
        _topContainer(context),
        SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 16),
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/images/profile.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  String userName = 'Demo User';
                  if (state is SignInLoadingSuccessState) {
                    print(state.successMessage.userName);
                    userName = state.successMessage.userName;
                  } else {
                    print('no loading state');
                  }
                  return Text(userName);
                },
              ),
              Text('9842529245'),
              SizedBox(height: MediaQuery.of(context).size.height * 0.09),
              ButtonWidgets(
                buttonIcon: Icons.person_outline,
                buttonText: 'Edit Profile',
                onTap: () {},
              ),
              ButtonWidgets(
                buttonIcon: Icons.category,
                buttonText: 'Category',
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryListPageView()));
                },
              ),
              ButtonWidgets(
                buttonIcon: Icons.list,
                buttonText: 'Ledger List',
                onTap: () {
                  context.read<LedgerBloc>().add(GetAllLedgersClickEvent());
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LedgerPageView()));
                },
              ),
              ButtonWidgets(
                buttonIcon: Icons.logout_outlined,
                buttonText: 'Logout',
                color: Colors.red,
                onTap: () async {
                  SharedPreferences preferences = await SharedPreferences.getInstance();
                  preferences.remove('loggedIn');

                  if (!context.mounted) return;

                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SignInPageView()), (route) => false);
                },
              ),
            ],
          ),
        )
      ],
    );
  }
}

Widget _topContainer(BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height * 0.18,
    color: AppColors.primaryColor,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.1),
        Text(
          'Profile',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: AppColors.whiteColor),
        ),
        SizedBox(height: 16),
      ],
    ),
  );
}

class ButtonWidgets extends StatelessWidget {
  final String buttonText;
  final IconData buttonIcon;
  final Color? color;
  final GestureTapCallback onTap;
  const ButtonWidgets({
    required this.buttonIcon,
    required this.buttonText,
    this.color = Colors.black,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(6),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 0.6,
              color: Colors.grey,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              buttonIcon,
              color: color,
            ),
            const SizedBox(width: 18),
            Text(
              buttonText,
              style: TextStyle(color: color),
            ),
            Spacer(),
            _buildCicularArrow(),
          ],
        ),
      ),
    );
  }
}

Widget _buildCicularArrow() {
  return Container(
    width: 18,
    height: 18,
    decoration: BoxDecoration(
      color: Colors.grey,
      shape: BoxShape.circle,
    ),
    child: Center(
      child: Icon(
        Icons.arrow_forward_ios,
        color: AppColors.whiteColor,
        size: 12,
      ),
    ),
  );
}
