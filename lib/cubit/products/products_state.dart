part of 'products_cubit.dart';

abstract class ProductsState {}

class ProductsInitial extends ProductsState {}

class ProductsLoaded extends ProductsState {
  final List<Product> products;
  final List<Product>? filteredData;
  final int? sortIndex;
  final bool sortAscending;
  final Product? selectedProduct;

  ProductsLoaded({
    required this.products,
    this.filteredData,
    this.sortIndex,
    required this.sortAscending,
    this.selectedProduct,
  });
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
