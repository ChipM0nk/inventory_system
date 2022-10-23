part of 'purchase_cubit.dart';

abstract class PurchaseState {}

class PurchaseInitial extends PurchaseState {}

class PurchaseLoaded extends PurchaseState {
  final List<Purchase> purchases;
  List<Purchase>? filteredData;
  int? sortIndex;
  final bool sortAscending;

  PurchaseLoaded(
      {required this.purchases,
      this.filteredData,
      this.sortIndex,
      required this.sortAscending});
}

//Add

class PurchaseAdded extends PurchaseState {}

//delete

class PurchaseDeleted extends PurchaseState {}

//update

class PurchaseUpdated extends PurchaseState {}

//error
