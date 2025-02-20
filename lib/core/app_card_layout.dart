import 'package:expense_tracker/core/app_colors.dart';
import 'package:flutter/material.dart';

class AppCardLayoutView extends StatelessWidget {
  final double marginBottom;
  final double paddingHorizontal;

  final Widget child;
  const AppCardLayoutView({
    this.marginBottom = 16,
    this.paddingHorizontal = 8,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: marginBottom),
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: paddingHorizontal),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
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
      child: child,
    );
  }
}
