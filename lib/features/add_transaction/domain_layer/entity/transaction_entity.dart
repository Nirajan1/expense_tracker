import 'package:equatable/equatable.dart';

class TransactionEntity extends Equatable {
  final int? id;
  final String amount;
  final String date;
  final String categoryFrom;
  final String categoryTo;
  final String type;
  const TransactionEntity({
    this.id,
    required this.amount,
    required this.date,
    required this.categoryFrom,
    required this.categoryTo,
    required this.type,
  });
  @override
  List<Object?> get props => [
        id,
        amount,
        date,
        categoryFrom,
        categoryTo,
        type,
      ];
}
