// ignore_for_file: must_be_immutable

import 'package:bloc/bloc.dart';
import 'package:edar_app/common/mixins/error_message_mixin.dart';
import 'package:edar_app/common/mixins/mixin_validations.dart';
import 'package:edar_app/cubit/invoice/proforma_field_mixin.dart';
import 'package:edar_app/cubit/invoice/invoice_field_mixin.dart';
import 'package:edar_app/cubit/invoice/invoice_item_field_mixin.dart';
import 'package:edar_app/data/model/invoice/invoice.dart';
import 'package:edar_app/data/repository/invoice_repository.dart';
import 'package:flutter/material.dart';

part 'save_invoice_state.dart';

class SaveInvoiceCubit extends Cubit<SaveInvoiceState>
    with
        ValidationMixin,
        InvoiceItemFieldMixin,
        ProformaFieldMixin,
        InvoiceFieldMixin,
        ErrorMessageMixin {
  final InvoiceRepository invoiceRepository = InvoiceRepository();

  SaveInvoiceCubit() : super(SaveInvoiceInitial());

  initDialog() {
    init();
    clearError();
    emit(SaveInvoiceInitial());
  }

  void reset() {
    init();
    emit(SaveInvoiceInitial());
  }

  void addInvoice() {
    emit(InvoiceSaving());
    Map<String, dynamic> invoiceObj = getInvoice().toJson();
    invoiceRepository.addInvoice(invoiceObj).then((returnMap) {
      emit(InvoiceSaved(
          invoiceNo: returnMap["invoiceNo"], poNumber: returnMap["poNumber"]));
    }).onError(
      (error, stackTrace) {
        emit(InvoiceSavingError());
        updateError('$error', stackTrace);
      },
    );
  }

  void voidInvoice(int invoiceId) {
    emit(InvoiceVoiding());
    invoiceRepository.voidInvoice(invoiceId).then((isVoided) {
      if (isVoided) {
        emit(InvoiceVoided());
      } else {
        emit(InvoiceSavingError());
        updateError(null, null);
      }
    }).onError(
      (error, stackTrace) {
        emit(InvoiceSavingError());
        updateError('$error', stackTrace);
      },
    );
  }

  void finalizeInvoice(int invoiceId) {
    emit(InvoiceSaving());
    invoiceRepository.finalizeInvoice(invoiceId).then((isFinalized) {
      if (isFinalized) {
        emit(InvoiceSaved());
      } else {
        emit(InvoiceSavingError());
        updateError(null, null);
      }
    }).onError(
      (error, stackTrace) {
        emit(InvoiceSavingError());
        updateError('$error', stackTrace);
      },
    );
  }

  loadInvoice(Invoice invoice) {
    updateCustomerName(invoice.customerName);
    invoice.customerAddress ?? updateCustomerAddress(invoice.customerAddress!);
    invoice.contactNo ?? updateCustomerContact(invoice.contactNo!);
    updatePurchaseDate(invoice.purchaseDate);
    updatePaymentTerm(invoice.paymentTerm);
    updatePaymentType(invoice.paymentType);
    updateTinNumber(invoice.tinNumber);
    // updateDueDate(invoice.dueDate);
    updateInvoiceItems(invoice.invoiceItems);
  }
}
