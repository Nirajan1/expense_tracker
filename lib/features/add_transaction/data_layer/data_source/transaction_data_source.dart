import 'package:expense_tracker/features/add_transaction/data_layer/model/transaction_model.dart';
import 'package:objectbox/objectbox.dart';

abstract class TransactionLocalDataSource {
  Future<void> addTransaction(TransactionModel transactionModel);
  Future<List<TransactionModel>> callTransaction();
  Future<void> deleteTransaction({required int id});
  Future<void> updateTransaction({required TransactionModel transactionModel});
}

class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
  final Store store;
  late final Box<TransactionModel> transactionBox;
  TransactionLocalDataSourceImpl(this.store) {
    transactionBox = store.box<TransactionModel>();
  }
  
  @override
  Future<void> addTransaction(TransactionModel transactionModel) async {
    // transactionBox.put(transactionModel);
    int assignedId = transactionBox.put(transactionModel);
    // print('Transaction added with ID: $assignedId'); // Debugging print
    transactionModel.id = assignedId; // Ensure the ID is saved
  }

  @override
  Future<List<TransactionModel>> callTransaction() async {
    return transactionBox.getAll();
  }

  @override
  Future<void> deleteTransaction({required int id}) async {
    bool exists = transactionBox.contains(id);
    if (exists) {
      transactionBox.remove(id);
      print("Transaction with ID: $id deleted.");
    } else {
      print("Transaction with ID: $id not found.");
    }
    // transactionBox.remove(id);
    // print('here is dta source $id');
    // final exists = transactionBox.contains(id);
    // if (exists) {
    //   transactionBox.remove(id);
    //   print('Transaction with ID: $id deleted.');
    // } else {
    //   print('Transaction ID: $id not found!');
    // }
    // final transactions = transactionBox.getAll();

    // if (transactions.isNotEmpty) {
    //   int firstTransactionId = transactions.first.id;
    //   print("Deleting transaction with ID: $firstTransactionId");
    //   transactionBox.remove(firstTransactionId);
    //   print("Transaction deleted successfully.");
    // } else {
    //   print("No transactions to delete.");
    // }
    // if (id >= 0 && id < transactions.length) {
    //   int transactionId = transactions[id].id;
    //   // print("Deleting transaction at index $id with ID: $transactionId");
    //   transactionBox.remove(transactionId);
    //   // print("Transaction deleted successfully.");
    // }
    //  else {
    //   print("Invalid index: $id. No transaction deleted.");
    // }
  }

  @override
  Future<void> updateTransaction({required TransactionModel transactionModel}) async {
    transactionBox.put(transactionModel);
    print("Transaction with ID: ${transactionModel.id} updated.");
  }
}
