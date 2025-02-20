import 'package:expense_tracker/features/ledger/domain_layer/entity/ledger_entity.dart';
import 'package:expense_tracker/features/ledger/domain_layer/repositories/ledger_repositories.dart';

class UpdateLedgerUseCase {
  final LedgerRepositories ledgerRepositories;
  const UpdateLedgerUseCase({required this.ledgerRepositories});

  Future<void> updateLedger({required LedgerEntity ledgerEntity}) async {
    await ledgerRepositories.updateLedger(ledgerEntity: ledgerEntity);
  }
}
