import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_tracker/features/ledger/domain_layer/entity/ledger_entity.dart';
import 'package:expense_tracker/features/ledger/domain_layer/user_case/add_ledger_use_case.dart';
import 'package:expense_tracker/features/ledger/domain_layer/user_case/delete_ledger_use_case.dart';
import 'package:expense_tracker/features/ledger/domain_layer/user_case/get_all_ledger_use_case.dart';
import 'package:expense_tracker/features/ledger/domain_layer/user_case/update_ledger_use_case.dart';

part 'ledger_event.dart';
part 'ledger_state.dart';

class LedgerBloc extends Bloc<LedgerEvent, LedgerState> {
  final AddLedgerUseCase addLedgerUseCase;
  final UpdateLedgerUseCase updateLedgerUseCase;
  final DeleteLedgerUseCase deleteLedgerUseCase;
  final GetAllLedgerUseCase getAllLedgerUseCase;
  LedgerBloc({
    required this.addLedgerUseCase,
    required this.updateLedgerUseCase,
    required this.deleteLedgerUseCase,
    required this.getAllLedgerUseCase,
  }) : super(LedgerInitial()) {
    on<LedgerAddClickEvent>(ledgerAddClickEvent);
    on<GetAllLedgersClickEvent>(getAllLedgersClickEvent);
    on<LedgerDeleteClickEvent>(ledgerDeleteClickEvent);
    on<LedgerUpdateClickEvent>(ledgerUpdateClickEvent);
    on<GroupSelectedClickEvent>(groupSelectedClickEvent);
  }
  FutureOr<void> ledgerAddClickEvent(LedgerAddClickEvent event, Emitter<LedgerState> emit) async {
    emit(LedgerLoadingState());
    try {
      print('bloc ${event.ledgerEntity}');
      await addLedgerUseCase.addLedger(ledgerEntity: event.ledgerEntity);
      emit(LedgerLoadedSuccessState());
      add(GetAllLedgersClickEvent());
    } catch (e) {
      emit(LegerErrorState(error: e.toString()));
    }
  }

  FutureOr<void> getAllLedgersClickEvent(GetAllLedgersClickEvent event, Emitter<LedgerState> emit) async {
    emit(LedgerLoadingState());
    try {
      final ledgerEntity = await getAllLedgerUseCase.getAllLedgers();
      print(ledgerEntity);
      emit(LedgerLoadedState(ledgerList: ledgerEntity));
    } catch (e) {
      emit(LegerErrorState(error: e.toString()));
    }
  }

  FutureOr<void> ledgerDeleteClickEvent(LedgerDeleteClickEvent event, Emitter<LedgerState> emit) async {
    emit(LedgerLoadingState());
    try {
      print(event.ledgerId);
      await deleteLedgerUseCase.deleteLedger(ledgerId: event.ledgerId);
      emit(LedgerLoadedSuccessState());
      add(GetAllLedgersClickEvent());
    } catch (e) {
      emit(LegerErrorState(error: e.toString()));
    }
  }

  FutureOr<void> ledgerUpdateClickEvent(LedgerUpdateClickEvent event, Emitter<LedgerState> emit) async {
    emit(LedgerLoadingState());
    try {
      await updateLedgerUseCase.updateLedger(ledgerEntity: event.ledgerEntity);
      emit(LedgerLoadedSuccessState());
      add(GetAllLedgersClickEvent());
    } catch (e) {
      emit(LegerErrorState(error: e.toString()));
    }
  }

  FutureOr<void> groupSelectedClickEvent(GroupSelectedClickEvent event, Emitter<LedgerState> emit) async {
    print('blockingv${event.group}');
    emit(GroupSelectedState(selectedGroup: event.group));
  }
}
