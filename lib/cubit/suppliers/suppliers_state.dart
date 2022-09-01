part of 'suppliers_cubit.dart';

abstract class SuppliersState {}

class SuppliersInitial extends SuppliersState {}

class SuppliersLoaded extends SuppliersState {
  final List<Supplier> suppliers;
  List<Supplier>? filteredData;
  int? sortIndex;
  final bool sortAscending;
  final Supplier? selectedSupplier;

  SuppliersLoaded({
    required this.suppliers,
    this.filteredData,
    this.sortIndex,
    required this.sortAscending,
    this.selectedSupplier,
  });
}

//Add
class AddingSupplier extends SuppliersState {}

class SupplierAdded extends SuppliersState {}

//delete
class DeletingSupplier extends SuppliersState {}

class SupplierDeleted extends SuppliersState {}

//update
class UpdatingSupplier extends SuppliersState {}

class SupplierUpdated extends SuppliersState {}

//error
class SupplierStateError extends SuppliersState {}
