import 'package:expense_tracker/features/ledger/data_layer/data_source/ledger_data_source.dart';
import 'package:expense_tracker/features/ledger/data_layer/models/ledger_model.dart';
import 'package:expense_tracker/features/ledger/domain_layer/entity/ledger_entity.dart';
import 'package:expense_tracker/features/ledger/domain_layer/repositories/ledger_repositories.dart';

class LedgerRepositoryImpl implements LedgerRepositories {
  final LedgerDataSource ledgerLocalDataSource;
  LedgerRepositoryImpl({required this.ledgerLocalDataSource});

  @override
  Future<void> addLedger({required LedgerEntity ledgerEntity}) async {
    final ledgerModel = LedgerModel(
      name: ledgerEntity.name,
      categoryType: ledgerEntity.categoryType,
      openingBalance: ledgerEntity.openingBalance,
      openingBalanceType: ledgerEntity.openingBalanceType,
      closingBalance: ledgerEntity.closingBalance,
    );
    await ledgerLocalDataSource.addLedger(ledgerModel: ledgerModel);
  }

  @override
  Future<void> deleteLedger({required int ledgerId}) async {
    await ledgerLocalDataSource.deleteLedger(id: ledgerId);
  }

  @override
  Future<List<LedgerEntity>> getAllLedgers() async {
    final ledgerModel = await ledgerLocalDataSource.getLedgers();
    return ledgerModel.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> updateLedger({required LedgerEntity ledgerEntity}) async {
    final ledgerModel = LedgerModel.fromEntity(ledgerEntity);
    return await ledgerLocalDataSource.updateLedger(ledgerModel: ledgerModel);
  }
}
