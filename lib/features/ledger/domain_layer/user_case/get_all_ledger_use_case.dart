import 'package:expense_tracker/features/ledger/domain_layer/entity/ledger_entity.dart';
import 'package:expense_tracker/features/ledger/domain_layer/repositories/ledger_repositories.dart';

class GetAllLedgerUseCase {
  final LedgerRepositories ledgerRepositories;
  const GetAllLedgerUseCase({required this.ledgerRepositories});
  Future<List<LedgerEntity>> getAllLedgers() async {
    return await ledgerRepositories.getAllLedgers();
  }
}
