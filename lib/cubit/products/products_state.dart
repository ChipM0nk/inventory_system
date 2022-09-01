part of 'products_cubit.dart';

abstract class ProductsState {}

class ProductsInitial extends ProductsState {}

class ProductsLoaded extends ProductsState {
  final List<Product> products;
  List<Product>? filteredData;
  int? sortIndex;
  final bool sortAscending;

  ProductsLoaded(
      {required this.products,
      this.filteredData,
      this.sortIndex,
      required this.sortAscending});
}

//Add
class AddingProduct extends ProductsState {}

class ProductAdded extends ProductsState {}

//delete
class DeletingProduct extends ProductsState {}

class ProductDeleted extends ProductsState {}

//update
class UpdatingProduct extends ProductsState {}

class ProductUpdated extends ProductsState {}

//error
class ProductStateError extends ProductsState {}
