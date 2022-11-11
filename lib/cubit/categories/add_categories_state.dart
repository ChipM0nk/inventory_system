part of 'add_categories_cubit.dart';

@immutable
abstract class SaveCategoriesState {}

class SaveCategoriesInitial extends SaveCategoriesState {
  final bool isAdding;

  SaveCategoriesInitial({this.isAdding = false});
}

class CategorySaving extends SaveCategoriesState {}

class CategorySaved extends SaveCategoriesState {}

class CategoryUpdating extends SaveCategoriesState {}

class CategoryUpdated extends SaveCategoriesState {}

class CategorySavingError extends SaveCategoriesState {}
