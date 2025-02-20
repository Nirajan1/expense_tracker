part of 'ledger_bloc.dart';

sealed class LedgerState extends Equatable {
  const LedgerState();

  @override
  List<Object> get props => [];
}

final class LedgerInitial extends LedgerState {}

class LedgerLoadingState extends LedgerState {}

class LedgerLoadedSuccessState extends LedgerState {}

class LegerErrorState extends LedgerState {
  final String error;
  const LegerErrorState({required this.error});
}

class LedgerLoadedState extends LedgerState {
  final List<LedgerEntity> ledgerList;
  const LedgerLoadedState({required this.ledgerList});
}
