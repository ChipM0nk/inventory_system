part of 'save_categories_cubit.dart';

@immutable
abstract class SaveCategoriesState {}

class SaveCategoriesInitial extends SaveCategoriesState {}

class CategorySaving extends SaveCategoriesState {}

class CategorySaved extends SaveCategoriesState {}

class CategorySavingError extends SaveCategoriesState {}
