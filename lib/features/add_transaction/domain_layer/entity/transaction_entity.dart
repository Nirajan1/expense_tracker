import 'package:equatable/equatable.dart';

class TransactionEntity extends Equatable {
  final int? id;
  final String amount;
  final String date;
  final String ledgerFrom;
  final String ledgerTo;
  final String type;
  const TransactionEntity({
    this.id,
    required this.amount,
    required this.date,
    required this.ledgerFrom,
    required this.ledgerTo,
    required this.type,
  });
  @override
  List<Object?> get props => [
        id,
        amount,
        date,
        ledgerFrom,
        ledgerTo,
        type,
      ];
}
