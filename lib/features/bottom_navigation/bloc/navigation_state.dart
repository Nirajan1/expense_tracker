part of 'navigation_bloc.dart';

@immutable
sealed class NavigationState {}

final class NavigationInitial extends NavigationState {}

final class ButtonTapState extends NavigationState {
  final int tappedIndex;
  ButtonTapState({required this.tappedIndex});
}
