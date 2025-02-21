part of 'ledger_bloc.dart';

sealed class LedgerEvent extends Equatable {
  const LedgerEvent();

  @override
  List<Object> get props => [];
}

class LedgerAddClickEvent extends LedgerEvent {
  final LedgerEntity ledgerEntity;
  const LedgerAddClickEvent({required this.ledgerEntity});
}

class LedgerUpdateClickEvent extends LedgerEvent {
  final LedgerEntity ledgerEntity;
  const LedgerUpdateClickEvent({required this.ledgerEntity});
}

class LedgerDeleteClickEvent extends LedgerEvent {
  final int ledgerId;
  const LedgerDeleteClickEvent({required this.ledgerId});
}

class GetAllLedgersClickEvent extends LedgerEvent {}

class GroupSelectedClickEvent extends LedgerEvent {
  final String group;
  const GroupSelectedClickEvent({required this.group});
}
