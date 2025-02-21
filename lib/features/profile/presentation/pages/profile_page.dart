import 'package:expense_tracker/core/app_colors.dart';
import 'package:expense_tracker/features/category/presentation/pages/category_list_page.dart';
import 'package:expense_tracker/features/ledger/presentation_layer/bloc/ledger_bloc.dart';
import 'package:expense_tracker/features/ledger/presentation_layer/pages/ledger_list_page.dart';
import 'package:expense_tracker/features/profile/presentation/widgets/card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePageView extends StatelessWidget {
  const ProfilePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16,
      children: [
        _topContainer(context),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: CardWidget(
            title: 'Category',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoryListPageView(),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: CardWidget(
            title: 'Ledger',
            onTap: () {
              context.read<LedgerBloc>().add(GetAllLedgersClickEvent());
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LedgerPageView(),
                ),
              );
            },
          ),
        ),
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
