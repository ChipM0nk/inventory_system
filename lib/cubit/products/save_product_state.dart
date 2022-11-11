part of 'save_product_cubit.dart';

@immutable
abstract class SaveProductState {}

class SaveProductInitial extends SaveProductState {}

class ProductSaving extends SaveProductState {}

class ProductSaved extends SaveProductState {}

class ProductSavingError extends SaveProductState {}
