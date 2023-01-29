// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:edar_app/data/model/purchase/purchase.dart';
import 'package:edar_app/data/model/purchase/purchase_item.dart';
import 'package:edar_app/data/model/supplier.dart';
import 'package:edar_app/common/mixins/mixin_validations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

@immutable
mixin PurchaseFieldMixin on ValidationMixin {
  final _supplierInvoiceController = BehaviorSubject<String>();
  final _purchaseDateController = BehaviorSubject<String>();
  final _batchCodeController = BehaviorSubject<String>();
  final _supplierController = BehaviorSubject<Supplier>();
  final _remarksController = BehaviorSubject<String>();
  final _purchaseItemListController = BehaviorSubject<List<PurchaseItem>>();
  final _totalAmountController = BehaviorSubject<double>();

  init() {
    List<PurchaseItem> initialList = [];

    _supplierInvoiceController.sink.addError("");
    _remarksController.sink.addError("");
    _supplierController.sink.addError("");
    _totalAmountController.sink.addError("");

    // _purchaseItemListController.sink.add(initialList);
    updatePurchaseItemList(initialList);
    String initialDate =
        DateFormat('dd-MMM-yy').format(DateTime.now()); //default
    updatePurchaseDate(initialDate);
  }

  //set format
  Stream<String> get supplierInvoiceStream => _supplierInvoiceController.stream;
  updatePurchaseNo(String fieldValue) {
    if (validTextLength(fieldValue, 4)) {
      _supplierInvoiceController.sink.add(fieldValue);
    } else {
      _supplierInvoiceController.sink.addError("Incorrect Format");
    }
  }

  //set format
  Stream<String> get purchaseDateStream => _purchaseDateController.stream;
  updatePurchaseDate(String dateTime) {
    _purchaseDateController.sink.add(dateTime);
  }

  //validate format
  Stream<String> get batchCodeStream => _batchCodeController.stream;
  updateBatchCode(String fieldValue) {
    if (validTextLength(fieldValue, 4)) {
      _batchCodeController.sink.add(fieldValue);
    } else {
      _batchCodeController.sink.addError("Incorrect Format");
    }
  }

  //set format
  Stream<Supplier> get supplierStream => _supplierController.stream;
  updateSupplier(Supplier? supplier) {
    if (supplier != null) {
      _supplierController.sink.add(supplier);
    } else {
      _supplierController.sink.addError("Please select a suplier");
    }

    List<PurchaseItem> purchaseItems = _purchaseItemListController.value;
    purchaseItems.clear();
    updatePurchaseItemList(purchaseItems);
  }

  //set format
  Stream<List<PurchaseItem>> get purchaseItemsStream =>
      _purchaseItemListController.stream;
  updatePurchaseItemList(List<PurchaseItem> purchaseItems) {
    _purchaseItemListController.sink.add(purchaseItems);
    updateTotalAmount(0.0);
  }

//set format
  Stream<String> get remarksStream => _remarksController.stream;
  updateRemarks(String remarks) {
    _remarksController.sink.add(remarks);
  }

  List<PurchaseItem> getPurchaseItems() {
    return _purchaseItemListController.hasValue
        ? _purchaseItemListController.value
        : [];
  }

  addPurchaseItem(PurchaseItem purchaseItem) {
    List<PurchaseItem> purchaseItems = _purchaseItemListController.value;
    purchaseItems.add(purchaseItem);
    _purchaseItemListController.sink.add(purchaseItems);

    calculateTotalAmount(purchaseItems);
  }

  updatePurchaseItem(PurchaseItem purchaseItem) {
    List<PurchaseItem> purchaseItems = _purchaseItemListController.value;
    purchaseItems[purchaseItems.indexWhere(
            (ii) => ii.purchaseItemId == purchaseItem.purchaseItemId)] =
        purchaseItem;
    _purchaseItemListController.sink.add(purchaseItems);
    calculateTotalAmount(purchaseItems);
  }

  removePurchaseItem(PurchaseItem purchaseItem) {
    List<PurchaseItem> purchaseItems = _purchaseItemListController.value;
    print('Removing ${purchaseItem.hashCode}');
    purchaseItems.remove(purchaseItem);
    _purchaseItemListController.sink.add(purchaseItems);
    calculateTotalAmount(purchaseItems);
  }

  //set format
  Stream<double> get totalAmountStream => _totalAmountController.stream;
  updateTotalAmount(double amount) {
    _totalAmountController.sink.add(amount.toPrecision(2));
  }

  calculateTotalAmount(List<PurchaseItem> purchaseItems) {
    double purchaseTotalAmount = purchaseItems.fold(
        0.0, (sum, element) => sum + element.itemTotalAmount);
    updateTotalAmount(purchaseTotalAmount);
  }

  double getTotal() {
    return _totalAmountController.value;
  }

  Stream<bool> get saveButtonValid => Rx.combineLatest4(
      supplierInvoiceStream,
      purchaseDateStream,
      purchaseItemsStream,
      totalAmountStream,
      (a, b, c, d) => true && _purchaseItemListController.value.isNotEmpty);

  Purchase getPurchase(int? purchaseId) {
    return Purchase(
      purchaseId: purchaseId,
      supplierInvoiceNo: _supplierInvoiceController.value,
      purchaseDate: _purchaseDateController.value,
      batchCode: _batchCodeController.valueOrNull,
      supplier: _supplierController.value,
      remarks: _remarksController.valueOrNull,
      purchaseItems: _purchaseItemListController.value,
      totalAmount: _totalAmountController.value,
    );
  }
}
