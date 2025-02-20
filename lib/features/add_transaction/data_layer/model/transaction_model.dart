import 'package:expense_tracker/features/add_transaction/domain_layer/entity/transaction_entity.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class TransactionModel {
  @Id(assignable: true)
  int id;
  String amount;
  String date;
  String categoryFrom;
  String categoryTo;
  String type;

  TransactionModel({
    this.id = 0,
    required this.amount,
    required this.date,
    required this.categoryFrom,
    required this.categoryTo,
    required this.type,
  });

  factory TransactionModel.fromEntity(TransactionEntity entity) {
    return TransactionModel(
      amount: entity.amount,
      date: entity.date,
      categoryFrom: entity.categoryFrom,
      categoryTo: entity.categoryTo,
      type: entity.type,
    );
  }

  TransactionEntity toEntity() {
    return TransactionEntity(
      id: id,
      amount: amount,
      date: date,
      categoryFrom: categoryFrom,
      categoryTo: categoryTo,
      type: type,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'date': date,
      'categoryFrom': categoryFrom,
      'categoryTo': categoryTo,
      'type': type,
    };
  }
}
