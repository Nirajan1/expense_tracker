import 'package:expense_tracker/features/ledger/data_layer/models/ledger_model.dart';
import 'package:objectbox/objectbox.dart';

abstract class LedgerDataSource {
  Future<void> addLedger({required LedgerModel ledgerModel});
  Future<void> updateLedger({required LedgerModel ledgerModel});
  Future<void> deleteLedger({required int id});
  Future<List<LedgerModel>> getLedgers({String? categoryType});
}

class LedgerDataSourceImpl implements LedgerDataSource {
  final Store store;
  late final Box<LedgerModel> ledgerBox;
  LedgerDataSourceImpl({required this.store}) {
    ledgerBox = store.box<LedgerModel>();
  }
  @override
  Future<void> addLedger({required LedgerModel ledgerModel}) async {
    ledgerBox.put(ledgerModel);
  }

  @override
  Future<void> deleteLedger({required int id}) async {
    try {
      final ledger = ledgerBox.get(id);

      if (ledger == null) {
        throw Exception('ledger not found');
      }
      ledgerBox.remove(id);
    } catch (e) {
      throw Exception('Failed to delete ledger: $e');
    }
  }

  @override
  Future<List<LedgerModel>> getLedgers({String? categoryType}) async {
    return ledgerBox.getAll();
    //  if (categoryType != null) {
    //   return ledgerBox
    //       .query(
    //         LedgerModel_.categoryType.equals(categoryType),
    //       )
    //       .build()
    //       .find();
    // } else {
    //   return ledgerBox.getAll();
    // }
  }

  @override
  Future<void> updateLedger({required LedgerModel ledgerModel}) async {
    ledgerBox.put(ledgerModel);
  }
}
