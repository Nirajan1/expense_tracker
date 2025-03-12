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

class GroupSelectedState extends LedgerState {
  final String selectedGroup;
  const GroupSelectedState({required this.selectedGroup});
}

// class LedgerUpdateClickLoadingState extends LedgerState {}

// class LedgerUpdateClickErrorState extends LedgerState {
//   final String errorMessage;
//   const LedgerUpdateClickErrorState({required this.errorMessage});
//   @override
//   List<Object> get props => [errorMessage];
// }

// class LedgerUpdateClickSuccessState extends LedgerState {
//   final String successMessage;
//   const LedgerUpdateClickSuccessState({required this.successMessage});
//   @override
//   List<Object> get props => [successMessage];
// }
