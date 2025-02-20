import 'package:expense_tracker/features/add_transaction/domain_layer/entity/transaction_entity.dart';
import 'package:expense_tracker/features/add_transaction/domain_layer/repositories/transaction_repositories.dart';

class UpdateTransactionUseCase {
  final TransactionRepositories transactionRepositories;
  UpdateTransactionUseCase({required this.transactionRepositories});
  Future<void> updateTransaction({required TransactionEntity transactionEntity}) async {
    return await transactionRepositories.updateTransaction(transactionEntity: transactionEntity);
  }
}
