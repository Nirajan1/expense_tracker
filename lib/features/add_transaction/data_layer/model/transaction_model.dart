import 'package:expense_tracker/features/add_transaction/domain_layer/entity/transaction_entity.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class TransactionModel {
  @Id()
  int id = 0;
  final String amount;
  final String date;
  final String ledgerFrom;
  final String ledgerTo;
  final String type;

  TransactionModel({this.id = 0, required this.amount, required this.date, required this.ledgerFrom, required this.ledgerTo, required this.type});

  factory TransactionModel.fromEntity(TransactionEntity entity) {
    return TransactionModel(id: entity.id!.toInt(), amount: entity.amount, date: entity.date, ledgerFrom: entity.ledgerFrom, ledgerTo: entity.ledgerTo, type: entity.type);
  }

  TransactionEntity toEntity() {
    return TransactionEntity(id: id, amount: amount, date: date, ledgerFrom: ledgerFrom, ledgerTo: ledgerTo, type: type);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'amount': amount, 'date': date, 'ledgerFrom': ledgerFrom, 'ledgerTo': ledgerTo, 'type': type};
  }
}
