import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_tracker/features/add_transaction/domain_layer/entity/transaction_entity.dart';
import 'package:expense_tracker/features/add_transaction/domain_layer/use_case/add_transaction_use_case.dart';
import 'package:expense_tracker/features/add_transaction/domain_layer/use_case/call_transaction_use_case.dart';
import 'package:expense_tracker/features/add_transaction/domain_layer/use_case/delete_transaction_use_case.dart';
import 'package:expense_tracker/features/add_transaction/domain_layer/use_case/update_transaction_use_case.dart';

part 'add_income_expense_event.dart';
part 'add_income_expense_state.dart';

class AddIncomeExpenseBloc extends Bloc<AddIncomeExpenseEvent, AddIncomeExpenseState> {
  final AddTransactionUseCase addTransactionUseCase;
  final CallTransactionUseCase callTransactionUseCase;
  final DeleteTransactionUseCase deleteTransactionUseCase;
  final UpdateTransactionUseCase updateTransactionUseCase;

  AddIncomeExpenseBloc({
    required this.addTransactionUseCase,
    required this.callTransactionUseCase,
    required this.deleteTransactionUseCase,
    required this.updateTransactionUseCase,
  }) : super(AddIncomeExpenseInitial()) {
    on<AddIncomeExpenseClickEvent>(addIncomeExpenseClickEvent);
    on<IncomeExpenseLoadEvent>(incomeExpenseLoadEvent);
    on<DeleteIncomeExpenseClickEvent>(deleteIncomeExpenseClickEvent);
    on<UpdateIncomeExpenseClickEvent>(updateIncomeExpenseClickEvent);
  }
  FutureOr<void> addIncomeExpenseClickEvent(AddIncomeExpenseClickEvent event, Emitter<AddIncomeExpenseState> emit) async {
    emit(TransactionLoadingState());
    try {
      await addTransactionUseCase.add(event.transactionEntity);
      add(IncomeExpenseLoadEvent());
      emit(TransactionSuccessState());
    } catch (e) {
      emit(TransactionErrorState(error: e.toString()));
    }
  }

  FutureOr<void> incomeExpenseLoadEvent(IncomeExpenseLoadEvent event, Emitter<AddIncomeExpenseState> emit) async {
    emit(TransactionLoadingState());
    try {
      final data = await callTransactionUseCase.callTransaction();
      emit(TransactionLoaded(transactionsEntity: data));
    } catch (e) {
      emit(TransactionErrorState(error: e.toString()));
    }
  }

  FutureOr<void> deleteIncomeExpenseClickEvent(DeleteIncomeExpenseClickEvent event, Emitter<AddIncomeExpenseState> emit) async {
    print(event.transactionId);
    await deleteTransactionUseCase.deleteTransaction(id: event.transactionId);
    emit(TransactionSuccessState());
    add(IncomeExpenseLoadEvent());
  }

  FutureOr<void> updateIncomeExpenseClickEvent(UpdateIncomeExpenseClickEvent event, Emitter<AddIncomeExpenseState> emit) async {
    await updateTransactionUseCase.updateTransaction(transactionEntity: event.transactionEntity);
    emit(TransactionSuccessState());
    add(IncomeExpenseLoadEvent());
  }
}
