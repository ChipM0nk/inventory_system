part of 'save_invoice_cubit.dart';

@immutable
abstract class SaveInvoiceState {}

class SaveInvoiceInitial extends SaveInvoiceState {}

class InvoiceSaving extends SaveInvoiceState {}

class InvoiceSaved extends SaveInvoiceState {}

class InvoiceSavingError extends SaveInvoiceState {}

class InvoiceVoiding extends SaveInvoiceState {}

class InvoiceVoided extends SaveInvoiceState {}

class InvoiceVoidingError extends SaveInvoiceState {}
