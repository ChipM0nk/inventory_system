part of 'save_suppliers_cubit.dart';

@immutable
abstract class SaveSuppliersState {}

class SaveSuppliersInitial extends SaveSuppliersState {}

class SupplierSaving extends SaveSuppliersState {}

class SupplierSaved extends SaveSuppliersState {}

class SupplierSavingError extends SaveSuppliersState {}
