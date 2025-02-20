import 'package:expense_tracker/features/add_transaction/domain_layer/entity/transaction_entity.dart';
import 'package:expense_tracker/features/add_transaction/domain_layer/repositories/transaction_repositories.dart';

class AddTransactionUseCase {
  final TransactionRepositories repositories;
  AddTransactionUseCase({required this.repositories});
  Future<void> add(TransactionEntity transactionEntity) async {
    return await repositories.addTransaction(transactionEntity: transactionEntity);
  }
}
