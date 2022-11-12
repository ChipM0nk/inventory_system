part of 'invoice_cubit.dart';

abstract class InvoiceState {}

class InvoiceInitial extends InvoiceState {}

class InvoiceLoaded extends InvoiceState {
  final List<Invoice> invoices;
  final List<Invoice>? filteredData;
  final int? sortIndex;
  final bool sortAscending;

  InvoiceLoaded({
    required this.invoices,
    this.filteredData,
    this.sortIndex,
    required this.sortAscending,
  });
}

class InvoiceLoading extends InvoiceState {}
