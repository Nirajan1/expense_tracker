part of 'navigation_bloc.dart';

@immutable
sealed class NavigationEvent {}

class ButtonTapEvent extends NavigationEvent {
  final int tappedIndex;
  ButtonTapEvent({required this.tappedIndex});
}
