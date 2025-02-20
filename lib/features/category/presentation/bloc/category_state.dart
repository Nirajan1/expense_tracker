part of 'category_bloc.dart';

sealed class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object> get props => [];
}

final class CategoryInitial extends CategoryState {}

class CategoryLoadingState extends CategoryState {}

class CategoryErrorState extends CategoryState {
  final String errorMessage;
  const CategoryErrorState({required this.errorMessage});
}

class CategoryLoadedState extends CategoryState {
  final List<CategoryEntity> categoryEntity;
  const CategoryLoadedState({required this.categoryEntity});
}
