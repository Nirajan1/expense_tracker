import 'package:equatable/equatable.dart';

class LedgerEntity extends Equatable {
  final int? id;
  final String name;
  final String categoryType;
  final int openingBalance;
  final String openingBalanceType;
  const LedgerEntity({
    this.id,
    required this.name,
    required this.categoryType,
    required this.openingBalance,
    required this.openingBalanceType,
  });
  @override
  List<Object?> get props => [
        id,
        name,
        categoryType,
        openingBalance,
      ];
}
