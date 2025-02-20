import 'package:expense_tracker/features/ledger/domain_layer/repositories/ledger_repositories.dart';

class DeleteLedgerUseCase {
  final LedgerRepositories ledgerRepositories;
  const DeleteLedgerUseCase({required this.ledgerRepositories});
  Future<void> deleteLedger({required int ledgerId}) async {
    return await ledgerRepositories.deleteLedger(ledgerId: ledgerId);
  }
}
