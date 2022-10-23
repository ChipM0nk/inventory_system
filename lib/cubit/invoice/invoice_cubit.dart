// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:edar_app/cubit/invoice/invoice_field_mixin.dart';
import 'package:edar_app/cubit/invoice/invoice_item_field_mixin.dart';
import 'package:edar_app/data/model/invoice/invoice.dart';
import 'package:edar_app/data/repository/invoice_repository.dart';
import 'package:edar_app/utils/error_message_mixin.dart';
import 'package:edar_app/utils/mixin_validations.dart';

part 'invoice_state.dart';

class InvoiceCubit extends Cubit<InvoiceState>
    with
        ValidationMixin,
        InvoiceItemFieldMixin,
        InvoiceFieldMixin,
        ErrorMessageMixin {
  final InvoiceRepository invoiceRepository;

  InvoiceCubit({required this.invoiceRepository}) : super(InvoiceInitial());

  void reset() {
    emit(InvoiceInitial());
  }

  void fetchInvoices() {
    invoiceRepository
        .fetchAll()
        .then((invoice) => {
              emit(InvoiceLoaded(
                invoices: invoice,
                sortIndex: null,
                sortAscending: true,
              )),
            })
        .onError((error, stackTrace) => updateError('$error'));
  }

  void sortInvoice<T>(
      Comparable<T> Function(Invoice) getField, int sortIndex, bool ascending) {
    final currentState = state;
    if (currentState is InvoiceLoaded) {
      final invoice = currentState.invoices;
      final filteredData = currentState.filteredData;

      final data = filteredData ?? invoice;
      data.sort((a, b) {
        final aValue = getField(a);
        final bValue = getField(b);
        return ascending
            ? Comparable.compare(aValue, bValue)
            : Comparable.compare(bValue, aValue);
      });
      emit(InvoiceLoaded(
          filteredData: data,
          invoices: invoice,
          sortIndex: sortIndex,
          sortAscending: ascending));
    }
  }

  void addInvoice() {
    Map<String, dynamic> invoiceObj = getInvoice(null).toJson();
    invoiceRepository.addInvoice(invoiceObj).then((isAdded) {
      if (isAdded) {
        // fetchInvoice();
        emit(InvoiceAdded());
        // fetchInvoice();
      } else {
        updateError(null);
      }
    }).onError((error, stackTrace) => updateError('$error'));
  }

  void updateInvoice(int invoiceId) {
    Map<String, dynamic> invoiceObj = getInvoice(invoiceId).toJson();
    invoiceRepository.udpateInvoice(invoiceObj, invoiceId).then((isUpdated) {
      if (isUpdated) {
        // fetchInvoice();
        emit(InvoiceUpdated());
      } else {
        updateError(null);
      }
    }).onError((error, stackTrace) => updateError('$error'));
  }

  void deleteInvoice(int invoiceId) {
    emit(DeletingInvoice());

    invoiceRepository.deleteInvoice(invoiceId).then((isDeleted) {
      if (isDeleted) {
        emit(InvoiceDeleted());
        // fetchInvoice();
      } else {
        updateError(null);
      }
    }).onError((error, stackTrace) => updateError('$error'));
  }

  void searchInvoice(String searchText) {
    final currentState = state;
    if (currentState is InvoiceLoaded) {
      final data = currentState.invoices;
      if (searchText.isEmpty) {
        emit(InvoiceLoaded(invoices: data, sortAscending: false));
      } else {
        final filteredData = data
            .where((invoice) =>
                invoice.customerName.contains(searchText) ||
                invoice.invoiceNo.contains(searchText))
            .toList();
        emit(InvoiceLoaded(
            filteredData: filteredData, invoices: data, sortAscending: true));
      }
    }
  }

  void selectedInvoice(Invoice? invoice) {
    final currentState = state;
    if (currentState is InvoiceLoaded) {
      final invoice = currentState.invoices;
      emit(InvoiceLoaded(
        invoices: invoice,
        sortAscending: true,
      ));
    }
  }

  loadInvoice(Invoice invoice) {
    updateInvoiceNumber(invoice.invoiceNo);
    updateCustomerName(invoice.customerName);
    invoice.customerAddress ?? updateCustomerAddress(invoice.customerAddress!);
    invoice.contactNo ?? updateCustomerContact(invoice.contactNo!);
    // updateSalesPerson(invoice.salesPerson);
    updatePoNumber(invoice.poNumber);
    updatePurchaseDate(invoice.purchaseDate);
    updatePaymentTerm(invoice.paymentTerm);
    updatePaymentType(invoice.paymentType);
    updateTinNumber(invoice.tinNumber);
    updateDueDate(invoice.dueDate);
    updateInvoiceItems(invoice.invoiceItems);
  }

  loadProduct() {
    print("null : ${getProduct() == null}");
    emit(InvoiceItemDialogOpened());
  }

  testProduct() {
    print("testnull : ${getProduct() == null}");
  }
}
