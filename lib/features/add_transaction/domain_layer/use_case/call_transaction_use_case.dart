import 'package:expense_tracker/features/add_transaction/domain_layer/entity/transaction_entity.dart';
import 'package:expense_tracker/features/add_transaction/domain_layer/repositories/transaction_repositories.dart';

class CallTransactionUseCase {
  final TransactionRepositories repositories;
  CallTransactionUseCase({required this.repositories});
  Future<List<TransactionEntity>> callTransaction() async {
    return await repositories.getAllTransactions();
  }
}
