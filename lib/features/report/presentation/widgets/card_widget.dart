import 'package:expense_tracker/core/app_card_layout.dart';
import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final String title;
  final Function() onTap;
  const CardWidget({required this.title, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return AppCardLayoutView(
      child: ListTile(
        onTap: onTap,
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.amber,
            shape: BoxShape.circle,
          ),
        ),
        title: Text(title),
      ),
    );
  }
}
