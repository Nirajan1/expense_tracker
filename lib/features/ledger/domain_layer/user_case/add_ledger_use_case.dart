import 'package:expense_tracker/features/ledger/domain_layer/entity/ledger_entity.dart';
import 'package:expense_tracker/features/ledger/domain_layer/repositories/ledger_repositories.dart';

class AddLedgerUseCase {
  final LedgerRepositories ledgerRepositories;
  const AddLedgerUseCase({required this.ledgerRepositories});
  Future<void> addLedger({required LedgerEntity ledgerEntity}) async {
    return await ledgerRepositories.addLedger(ledgerEntity: ledgerEntity);
  }
}
