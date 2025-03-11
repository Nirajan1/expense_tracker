import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_tracker/features/category/domain_layer/entity/category_entity.dart';
import 'package:expense_tracker/features/category/domain_layer/use_case/get_all_category_use_case.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetAllCategoryUseCase getAllCategoryUseCase;
  CategoryBloc({
    required this.getAllCategoryUseCase,
  }) : super(CategoryInitial()) {
    on<GetAllCategoryClickEvent>(getAllCategoryClickEvent);
  }

  FutureOr<void> getAllCategoryClickEvent(GetAllCategoryClickEvent event, Emitter<CategoryState> emit) async {
    emit(CategoryLoadingState());
    try {
      await Future.delayed(const Duration(seconds: 1));
      final categoryEntity = await getAllCategoryUseCase.getAllCategory();
      emit(CategoryLoadedState(categoryEntity: categoryEntity));
    } catch (e) {
      emit(CategoryErrorState(errorMessage: e.toString()));
    }
  }
}
