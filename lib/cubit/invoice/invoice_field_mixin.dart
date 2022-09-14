// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:edar_app/data/model/invoice/invoice.dart';
import 'package:edar_app/data/model/invoice/invoice_item.dart';
import 'package:edar_app/data/model/user.dart';
import 'package:edar_app/utils/mixin_validations.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

mixin InvoiceFieldMixin on ValidationMixin {
  late var _invoiceNumberController;
  late var _customerNameController;
  late var _customerAddressController;
  late var _customerContactController;
  late var _salesPersonController;
  late var _poNumberController;
  late var _purchaseDateController;
  late var _paymentTypeController;
  late var _paymentTermController;
  late var _tinNumberController;
  late var _dueDateController;
  late var _invoiceItemListController;
  late var _invoiceTotalAmountController;

  List<InvoiceItem> initialList = [];

  init() {
    _invoiceNumberController = BehaviorSubject<String>();
    _customerNameController = BehaviorSubject<String>();
    _customerAddressController = BehaviorSubject<String>();
    _customerContactController = BehaviorSubject<String>();
    _salesPersonController = BehaviorSubject<User>();
    _poNumberController = BehaviorSubject<String>();
    _purchaseDateController = BehaviorSubject<String>();
    _paymentTermController = BehaviorSubject<String>();
    _paymentTypeController = BehaviorSubject<String>();
    _tinNumberController = BehaviorSubject<String>();
    _dueDateController = BehaviorSubject<String>();
    _invoiceItemListController = BehaviorSubject<List<InvoiceItem>>();
    _invoiceTotalAmountController = BehaviorSubject<double>();
    _invoiceItemListController.sink.add(initialList);

    //test
    User salesPerson = const User(
        username:
            "23432"); //TODO Change to actual user from localStorage after login
    _salesPersonController.sink.add(salesPerson);
    _paymentTypeController.sink.add('Cash');

    String initialDate =
        DateFormat('dd-MMM-yy').format(DateTime.now()); //default
    updatePurchaseDate(initialDate);
    updateDueDate(initialDate);
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

  Stream<User> get salesPersonStream => _salesPersonController.stream;
  updateSalesPerson(User user) {
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

  /// Invoice Item List
  Stream<List<InvoiceItem>> get invoiceItemsStream =>
      _invoiceItemListController.stream;
  updateInvoiceItems(List<InvoiceItem> invoiceItems) {
    _dueDateController.sink.add(invoiceItems);
  }

  List<InvoiceItem>? getInvoiceItems() {
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
    print("update amount");
    _invoiceTotalAmountController.sink.add(totalAmount);
  }

  calculateTotalAmount(List<InvoiceItem> invoiceItems) {
    double invoiceTotalAmount =
        invoiceItems.fold(0.0, (sum, element) => sum + element.amount);
    print("Total Amount: ${invoiceTotalAmount}");
    updateTotalAmount(invoiceTotalAmount);
  }

  double getInvoiceTotalAmount() {
    return _invoiceTotalAmountController.hasValue
        ? _invoiceTotalAmountController.value
        : 0.0;
  }

  ///invoice item list
  Stream<bool> get buttonValid => Rx.combineLatest9(
      customerNameStream,
      salesPersonStream,
      poNumberStream,
      purchaseDateStream,
      paymentTypeStream,
      paymentTermStream,
      tinNumberStream,
      dueDateStream,
      invoiceItemsStream,
      (a, b, c, d, e, f, g, h, i) =>
          true &&
          _invoiceItemListController.hasValue &&
          _invoiceItemListController.value.isNotEmpty);

  Invoice getInvoice(int? invoiceId) {
    return Invoice(
      invoiceNumber: _invoiceNumberController.value,
      customerName: _customerNameController.value,
      customerAddress: _customerAddressController.value,
      contactNo: _customerContactController.value,
      salesPerson: _salesPersonController.value,
      poNumber: _poNumberController.value,
      purchaseDate: _purchaseDateController.value,
      paymentType: _paymentTypeController.value,
      paymentTerm: _paymentTermController.value,
      tinNumber: _tinNumberController.value,
      dueDate: _dueDateController.value,
      invoiceItems: _invoiceItemListController.value,
      totalAmount: _invoiceTotalAmountController.value,
    );
  }
}
