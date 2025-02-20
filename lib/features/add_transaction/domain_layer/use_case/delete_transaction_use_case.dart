import 'package:expense_tracker/features/add_transaction/domain_layer/repositories/transaction_repositories.dart';

class DeleteTransactionUseCase {
  final TransactionRepositories repositories;
  DeleteTransactionUseCase({required this.repositories});
  Future<void> deleteTransaction({required int id}) {
    print('delete use case called');
    return repositories.deleteTransactions(id: id);
  }
}
