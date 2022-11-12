// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:edar_app/common/mixins/search_param_mixin.dart';
import 'package:edar_app/data/model/invoice/invoice.dart';
import 'package:edar_app/data/repository/invoice_repository.dart';
import 'package:edar_app/common/mixins/error_message_mixin.dart';

part 'invoice_state.dart';

// ignore: must_be_immutable
class InvoiceCubit extends Cubit<InvoiceState>
    with SearchParamMixin, ErrorMessageMixin {
  final InvoiceRepository invoiceRepository = InvoiceRepository();

  InvoiceCubit() : super(InvoiceInitial());

  void fetchInvoices() {
    invoiceRepository
        .fetchAll()
        .then((invoices) => {
              emit(InvoiceLoaded(
                invoices: invoices,
                sortIndex: null,
                sortAscending: true,
              )),
            })
        .onError((error, stackTrace) => updateError('$error', stackTrace));
  }

  void fetchInvoicesWithParam() {
    emit(InvoiceLoading());
    Map<String, dynamic> paramObj = getParam()!.toJson();
    invoiceRepository
        .fetchWithParam(paramObj)
        .then((invoices) => {
              emit(InvoiceLoaded(
                invoices: invoices,
                sortIndex: null,
                sortAscending: true,
              )),
            })
        .onError((error, stackTrace) => updateError('$error', stackTrace));
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
}
