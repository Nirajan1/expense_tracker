import 'package:equatable/equatable.dart';

class LedgerEntity extends Equatable {
  final int? id;
  final String name;
  final String categoryType;
  final int openingBalance;
  final String openingBalanceType;
  final String closingBalance;
  const LedgerEntity({
    this.id,
    required this.name,
    required this.categoryType,
    required this.openingBalance,
    required this.openingBalanceType,
    required this.closingBalance,
  });
  @override
  List<Object?> get props => [
        id,
        name,
        categoryType,
        openingBalance,
        openingBalanceType,
        closingBalance,
      ];
}
