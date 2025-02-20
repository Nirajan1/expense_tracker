import 'package:expense_tracker/features/add_transaction/domain_layer/entity/transaction_entity.dart';

abstract class TransactionRepositories {
  Future<void> addTransaction({required TransactionEntity transactionEntity});
  Future<List<TransactionEntity>> getAllTransactions();
  Future<void> deleteTransactions({required int id});
  Future<void> updateTransaction({required TransactionEntity transactionEntity});
}
