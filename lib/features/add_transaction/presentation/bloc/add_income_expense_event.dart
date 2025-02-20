part of 'add_income_expense_bloc.dart';

sealed class AddIncomeExpenseEvent extends Equatable {
  const AddIncomeExpenseEvent();

  @override
  List<Object> get props => [];
}

class AddIncomeExpenseClickEvent extends AddIncomeExpenseEvent {
  final TransactionEntity transactionEntity;
  const AddIncomeExpenseClickEvent({required this.transactionEntity});
}

class IncomeExpenseLoadEvent extends AddIncomeExpenseEvent {}

class DeleteIncomeExpenseClickEvent extends AddIncomeExpenseEvent {
  final int transactionId;
  const DeleteIncomeExpenseClickEvent({required this.transactionId});
}

class UpdateIncomeExpenseClickEvent extends AddIncomeExpenseEvent {
  final TransactionEntity transactionEntity;
  const UpdateIncomeExpenseClickEvent({required this.transactionEntity});
}
