import 'package:expense_tracker/features/add_transaction/data_layer/data_source/transaction_data_source.dart';
import 'package:expense_tracker/features/add_transaction/data_layer/model/transaction_model.dart';
import 'package:expense_tracker/features/add_transaction/domain_layer/entity/transaction_entity.dart';
import 'package:expense_tracker/features/add_transaction/domain_layer/repositories/transaction_repositories.dart';

class TransactionRepositoryImpl implements TransactionRepositories {
  final TransactionLocalDataSource transactionLocalDataSource;
  TransactionRepositoryImpl({required this.transactionLocalDataSource});

  @override
  Future<void> addTransaction({required TransactionEntity transactionEntity}) async {
    final transactionModel = TransactionModel(
      amount: transactionEntity.amount,
      date: transactionEntity.date,
      ledgerFrom: transactionEntity.ledgerFrom,
      ledgerTo: transactionEntity.ledgerTo,
      type: transactionEntity.type,
    );
    return await transactionLocalDataSource.addTransaction(transactionModel);
  }

  @override
  Future<List<TransactionEntity>> getAllTransactions() async {
    final transactionModel = await transactionLocalDataSource.callTransaction();
    print('Transaction is ${transactionModel.map((model) => model.toEntity()).toList()}');
    return transactionModel.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> deleteTransactions({required int id}) async {
    print('deleting id $id');
    return await transactionLocalDataSource.deleteTransaction(id: id);
  }

  @override
  Future<void> updateTransaction({required TransactionEntity transactionEntity}) async {
    final transactionModel = TransactionModel.fromEntity(transactionEntity);
    print('data_layer repository impl :${transactionModel.id}');
    return await transactionLocalDataSource.updateTransaction(transactionModel: transactionModel);
  }
}
