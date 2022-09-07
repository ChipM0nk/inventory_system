part of 'invoice_cubit.dart';

abstract class InvoiceState {}

class InvoiceInitial extends InvoiceState {}

class InvoiceLoaded extends InvoiceState {
  final List<Invoice> invoice;
  final List<Invoice>? filteredData;
  final int? sortIndex;
  final bool sortAscending;

  InvoiceLoaded({
    required this.invoice,
    this.filteredData,
    this.sortIndex,
    required this.sortAscending,
  });
}

//Add
class AddingInvoice extends InvoiceState {}

class InvoiceAdded extends InvoiceState {}

//delete
class DeletingInvoice extends InvoiceState {}

class InvoiceDeleted extends InvoiceState {}

//update
class UpdatingInvoice extends InvoiceState {}

class InvoiceUpdated extends InvoiceState {}

//dialog box

class OpeningInvoiceItemDialog extends InvoiceState {}

class InvoiceItemDialogOpened extends InvoiceState {}

//error
class InvoiceStateError extends InvoiceState {}
