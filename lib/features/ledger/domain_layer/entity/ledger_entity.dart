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

  LedgerEntity copyWith({
    int? id,
    String? name,
    String? categoryType,
    int? openingBalance,
    String? openingBalanceType,
    String? closingBalance,
  }) {
    return LedgerEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      categoryType: categoryType ?? this.categoryType,
      openingBalance: openingBalance ?? this.openingBalance,
      openingBalanceType: openingBalanceType ?? this.openingBalanceType,
      closingBalance: closingBalance ?? this.closingBalance,
    );
  }
}
