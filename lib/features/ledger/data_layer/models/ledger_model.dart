import 'package:expense_tracker/features/ledger/domain_layer/entity/ledger_entity.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class LedgerModel {
  @Id()
  int id = 0;
  final String name;
  final String categoryType;
  final int openingBalance;
  final String openingBalanceType;

  LedgerModel({
    this.id = 0,
    required this.name,
    required this.categoryType,
    required this.openingBalance,
    required this.openingBalanceType,
  });

  factory LedgerModel.fromEntity(LedgerEntity ledgerEntity) {
    return LedgerModel(
      id: ledgerEntity.id,
      name: ledgerEntity.name,
      categoryType: ledgerEntity.categoryType,
      openingBalance: ledgerEntity.openingBalance,
      openingBalanceType: ledgerEntity.openingBalanceType,
    );
  }
  LedgerEntity toEntity() {
    return LedgerEntity(
      id: id,
      name: name,
      categoryType: categoryType,
      openingBalance: openingBalance,
      openingBalanceType: openingBalanceType,
    );
  }
}
