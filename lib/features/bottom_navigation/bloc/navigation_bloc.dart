import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'navigation_event.dart';
part 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(NavigationInitial()) {
    on<ButtonTapEvent>(buttonTapEvent);
  }
}

FutureOr<void> buttonTapEvent(ButtonTapEvent event, Emitter<NavigationState> emit) async {
  emit(ButtonTapState(tappedIndex: event.tappedIndex));
}
