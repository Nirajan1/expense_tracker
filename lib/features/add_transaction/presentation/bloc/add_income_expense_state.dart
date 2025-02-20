part of 'add_income_expense_bloc.dart';

sealed class AddIncomeExpenseState extends Equatable {
  const AddIncomeExpenseState();

  @override
  List<Object> get props => [];
}

final class AddIncomeExpenseInitial extends AddIncomeExpenseState {}

class TransactionLoadingState extends AddIncomeExpenseState {}

class TransactionSuccessState extends AddIncomeExpenseState {}

class TransactionLoaded extends AddIncomeExpenseState {
  final List<TransactionEntity> transactionsEntity;
  const TransactionLoaded({required this.transactionsEntity});
}

class TransactionErrorState extends AddIncomeExpenseState {
  final String error;
  const TransactionErrorState({required this.error});
}
