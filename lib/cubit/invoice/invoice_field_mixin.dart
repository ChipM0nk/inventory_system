// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:edar_app/data/model/invoice/invoice.dart';
import 'package:edar_app/data/model/invoice/invoice_item.dart';
import 'package:edar_app/utils/mixin_validations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

@immutable
mixin InvoiceFieldMixin on ValidationMixin {
  final _invoiceNumberController = BehaviorSubject<String>();
  final _customerNameController = BehaviorSubject<String>();
  final _customerAddressController = BehaviorSubject<String>();
  final _customerContactController = BehaviorSubject<String>();
  final _salesPersonController = BehaviorSubject<String>();
  final _poNumberController = BehaviorSubject<String>();
  final _purchaseDateController = BehaviorSubject<String>();
  final _paymentTypeController = BehaviorSubject<String>();
  final _paymentTermController = BehaviorSubject<String>();
  final _tinNumberController = BehaviorSubject<String>();
  final _dueDateController = BehaviorSubject<String>();
  final _remarksController = BehaviorSubject<String>();
  final _invoiceItemListController = BehaviorSubject<List<InvoiceItem>>();
  final _invoiceTotalAmountController = BehaviorSubject<double>();

  init() {
    List<InvoiceItem> initialList = [];
    _invoiceNumberController.sink.addError("");
    _customerNameController.sink.addError("");
    _customerAddressController.sink.addError("");
    _customerContactController.sink.addError("");
    _salesPersonController.sink.addError("");
    _poNumberController.sink.addError("");
    _purchaseDateController.sink.addError("");
    _paymentTermController.sink.addError("");
    _paymentTypeController.sink.addError("");
    _tinNumberController.sink.addError("");
    _dueDateController.sink.addError("");
    _remarksController.sink.addError("");

    _invoiceItemListController.sink.add(initialList);
    _paymentTypeController.sink.add('Cash');

    String initialDate =
        DateFormat('dd-MMM-yy').format(DateTime.now()); //default
    updatePurchaseDate(initialDate);
    updateDueDate(initialDate);
    updateTotalAmount(0.00);
  }

  Stream<String> get invoiceNumberStream => _invoiceNumberController.stream;
  updateInvoiceNumber(String fieldValue) {
    if (validTextLength(fieldValue, 4)) {
      _invoiceNumberController.sink.add(fieldValue);
    } else {
      _invoiceNumberController.sink
          .addError("Please enter text with length greater than 4");
    }
  }

  Stream<String> get customerNameStream => _customerNameController.stream;
  updateCustomerName(String fieldValue) {
    if (validTextLength(fieldValue, 4)) {
      _customerNameController.sink.add(fieldValue);
    } else {
      _customerNameController.sink
          .addError("Please enter text with length greater than 4");
    }
  }

  Stream<String> get customerAddressStream => _customerAddressController.stream;
  updateCustomerAddress(String fieldValue) {
    if (validTextLength(fieldValue, 4)) {
      _customerAddressController.sink.add(fieldValue);
    } else {
      _customerAddressController.sink
          .addError("Please enter text with length greater than 4");
    }
  }

  Stream<String> get customerContactStream => _customerContactController.stream;
  updateCustomerContact(String fieldValue) {
    if (validTextLength(fieldValue, 4)) {
      _customerContactController.sink.add(fieldValue);
    } else {
      _customerContactController.sink
          .addError("Please enter text with length greater than 4");
    }
  }

  Stream<String> get salesPersonStream => _salesPersonController.stream;
  updateSalesPerson(String user) {
    _salesPersonController.sink.add(user);
  }

  Stream<String> get poNumberStream => _poNumberController.stream;
  updatePoNumber(String fieldValue) {
    if (validTextLength(fieldValue, 4)) {
      _poNumberController.sink.add(fieldValue);
    } else {
      _poNumberController.sink
          .addError("Please enter text with length greater than 4");
    }
  }

//TODO: Create date validator
  Stream<String> get purchaseDateStream => _purchaseDateController.stream;
  updatePurchaseDate(String dateTime) {
    _purchaseDateController.sink.add(dateTime);
  }

  Stream<String> get paymentTypeStream => _paymentTypeController.stream;
  updatePaymentType(String fieldValue) {
    _paymentTypeController.sink.add(fieldValue);
    print("update payment type: ${_paymentTypeController.value}");
  }

  Stream<String> get paymentTermStream => _paymentTermController.stream;
  updatePaymentTerm(String fieldValue) {
    if (validTextLength(fieldValue, 4)) {
      _paymentTermController.sink.add(fieldValue);
    } else {
      _paymentTermController.sink
          .addError("Please enter text with length greater than 4");
    }
  }

  String getPaymentType() {
    return _paymentTypeController.value;
  }

  Stream<String> get tinNumberStream => _tinNumberController.stream;
  updateTinNumber(String fieldValue) {
    if (validTextLength(fieldValue, 4)) {
      _tinNumberController.sink.add(fieldValue);
    } else {
      _tinNumberController.sink
          .addError("Please enter text with length greater than 4");
    }
  }

  Stream<String> get dueDateStream => _dueDateController.stream;
  updateDueDate(String dateTime) {
    _dueDateController.sink.add(dateTime);
  }

  Stream<String> get remarksStream => _remarksController.stream;
  updateRemarks(String remarks) {
    _remarksController.sink.add(remarks);
  }

  /// Invoice Item List
  Stream<List<InvoiceItem>> get invoiceItemsStream =>
      _invoiceItemListController.stream;
  updateInvoiceItems(List<InvoiceItem> invoiceItems) {
    _invoiceItemListController.sink.add(invoiceItems);
  }

  List<InvoiceItem> getInvoiceItems() {
    return _invoiceItemListController.hasValue
        ? _invoiceItemListController.value
        : [];
  }

  addInvoiceItem(InvoiceItem invoiceItem) {
    List<InvoiceItem> invoiceItems = _invoiceItemListController.value;
    invoiceItems.add(invoiceItem);
    _invoiceItemListController.sink.add(invoiceItems);

    calculateTotalAmount(invoiceItems);
  }

  updateInvoiceItem(InvoiceItem invoiceItem) {
    List<InvoiceItem> invoiceItems = _invoiceItemListController.value;
    invoiceItems[invoiceItems.indexWhere(
        (ii) => ii.invoiceitemId == invoiceItem.invoiceitemId)] = invoiceItem;
    _invoiceItemListController.sink.add(invoiceItems);
    calculateTotalAmount(invoiceItems);
  }

  removeInvoiceItem(InvoiceItem invoiceItem) {
    List<InvoiceItem> invoiceItems = _invoiceItemListController.value;
    invoiceItems.remove(invoiceItem);
    _invoiceItemListController.sink.add(invoiceItems);
    calculateTotalAmount(invoiceItems);
  }

  Stream<double> get totalAmountStream => _invoiceTotalAmountController.stream;

  updateTotalAmount(double totalAmount) {
    _invoiceTotalAmountController.sink.add(totalAmount.toPrecision(2));
  }

  calculateTotalAmount(List<InvoiceItem> invoiceItems) {
    double invoiceTotalAmount =
        invoiceItems.fold(0.0, (sum, element) => sum + element.totalAmount);
    updateTotalAmount(invoiceTotalAmount);
  }

  double getInvoiceTotalAmount() {
    return _invoiceTotalAmountController.hasValue
        ? _invoiceTotalAmountController.value
        : 0.0;
  }

  ///invoice item list
  Stream<bool> get buttonValid => Rx.combineLatest8(
      customerNameStream,
      poNumberStream,
      purchaseDateStream,
      paymentTypeStream,
      paymentTermStream,
      tinNumberStream,
      dueDateStream,
      invoiceItemsStream,
      (a, b, c, d, e, f, g, h) =>
          true && _invoiceItemListController.value.length > 0);

  Invoice getInvoice(int? invoiceId) {
    return Invoice(
      invoiceNo: _invoiceNumberController.value,
      customerName: _customerNameController.value,
      customerAddress: _customerAddressController.value,
      contactNo: _customerContactController.value,
      poNumber: _poNumberController.value,
      purchaseDate: _purchaseDateController.value,
      paymentType: _paymentTypeController.value,
      paymentTerm: _paymentTermController.value,
      tinNumber: _tinNumberController.value,
      dueDate: _dueDateController.value,
      remarks: _remarksController.valueOrNull,
      invoiceItems: _invoiceItemListController.value,
      totalAmount: _invoiceTotalAmountController.value,
    );
  }

  double getTotal() {
    return _invoiceTotalAmountController.value;
  }
}
