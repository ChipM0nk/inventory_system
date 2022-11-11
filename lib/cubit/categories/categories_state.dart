part of 'categories_cubit.dart';

abstract class CategoriesState {}

class CategoriesInitial extends CategoriesState {}

class CategoriesLoaded extends CategoriesState {
  final List<Category> categories;
  final List<Category>? filteredData;
  final int? sortIndex;
  final bool sortAscending;

  CategoriesLoaded({
    required this.categories,
    this.filteredData,
    this.sortIndex,
    required this.sortAscending,
  });
}

//delete

class CategoryDeleted extends CategoriesState {}
