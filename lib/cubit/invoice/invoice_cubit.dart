// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:edar_app/cubit/invoice/invoice_field_mixin.dart';
import 'package:edar_app/cubit/invoice/invoice_item_field_mixin.dart';
import 'package:edar_app/data/model/invoice/invoice.dart';
import 'package:edar_app/data/repository/invoice_repository.dart';
import 'package:edar_app/utils/mixin_validations.dart';

part 'invoice_state.dart';

class InvoiceCubit extends Cubit<InvoiceState>
    with ValidationMixin, InvoiceItemFieldMixin, InvoiceFieldMixin {
  final InvoiceRepository invoiceRepository;

  InvoiceCubit({required this.invoiceRepository}) : super(InvoiceInitial());

  void fetchInvoice() {
    invoiceRepository.fetchAll().then((invoice) => {
          emit(InvoiceLoaded(
            invoice: invoice,
            sortIndex: null,
            sortAscending: true,
          )),
        });
  }

  void sortInvoice<T>(
      Comparable<T> Function(Invoice) getField, int sortIndex, bool ascending) {
    final currentState = state;
    if (currentState is InvoiceLoaded) {
      final invoice = currentState.invoice;
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
          invoice: invoice,
          sortIndex: sortIndex,
          sortAscending: ascending));
    }
  }

  void addInvoice() {
    emit(AddingInvoice());
    Map<String, dynamic> invoiceObj = getInvoice(null).toJson();
    invoiceRepository.addInvoice(invoiceObj).then((isAdded) {
      if (isAdded) {
        // fetchInvoice();
        emit(InvoiceAdded());
        // fetchInvoice();
      } else {
        emit(InvoiceStateError());
      }
    });
  }

  void updateInvoice(int invoiceId) {
    emit(UpdatingInvoice());
    Map<String, dynamic> invoiceObj = getInvoice(invoiceId).toJson();
    invoiceRepository.udpateInvoice(invoiceObj, invoiceId!).then((isUpdated) {
      if (isUpdated) {
        // fetchInvoice();
        emit(InvoiceUpdated());
        fetchInvoice();
      } else {
        emit(InvoiceStateError());
      }
    });
  }

  void deleteInvoice(int invoiceId) {
    emit(DeletingInvoice());

    invoiceRepository.deleteInvoice(invoiceId).then((isDeleted) {
      if (isDeleted) {
        emit(InvoiceDeleted());
        fetchInvoice();
      } else {
        emit(InvoiceStateError());
      }
    });
  }

  void searchInvoice(String searchText) {
    final currentState = state;
    if (currentState is InvoiceLoaded) {
      final data = currentState.invoice;
      if (searchText.isEmpty) {
        emit(InvoiceLoaded(invoice: data, sortAscending: false));
      } else {
        final filteredData = data
            .where((invoice) =>
                invoice.customerName.contains(searchText) ||
                invoice.invoiceNumber.contains(searchText))
            .toList();
        emit(InvoiceLoaded(
            filteredData: filteredData, invoice: data, sortAscending: true));
      }
    }
  }

  void selectedInvoice(Invoice? invoice) {
    final currentState = state;
    if (currentState is InvoiceLoaded) {
      final invoice = currentState.invoice;
      emit(InvoiceLoaded(
        invoice: invoice,
        sortAscending: true,
      ));
    }
  }

  loadInvoice(Invoice invoice) {
    updateInvoiceNumber(invoice.invoiceNumber);
    updateCustomerName(invoice.customerName);
    invoice.customerAddress ?? updateCustomerAddress(invoice.customerAddress!);
    invoice.contactNo ?? updateCustomerContact(invoice.contactNo!);
    updateSalesPerson(invoice.salesPerson);
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
