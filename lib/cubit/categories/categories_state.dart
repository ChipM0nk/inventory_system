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

//Add
class AddingCategory extends CategoriesState {}

class CategoryAdded extends CategoriesState {}

//delete
class DeletingCategory extends CategoriesState {}

class CategoryDeleted extends CategoriesState {}

//update
class UpdatingCategory extends CategoriesState {}

class CategoryUpdated extends CategoriesState {}

//error
class CategoryStateError extends CategoriesState {}
