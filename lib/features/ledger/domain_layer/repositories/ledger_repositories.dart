import 'package:expense_tracker/features/ledger/domain_layer/entity/ledger_entity.dart';

abstract class LedgerRepositories {
  Future<void> addLedger({required LedgerEntity ledgerEntity});
  Future<void> updateLedger({required LedgerEntity ledgerEntity});
  Future<void> deleteLedger({required int ledgerId});
  Future<List<LedgerEntity>> getAllLedgers();
}
