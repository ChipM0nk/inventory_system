// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:edar_app/data/model/purchase/purchase.dart';
import 'package:edar_app/data/model/purchase/purchase_item.dart';
import 'package:edar_app/data/model/supplier.dart';
import 'package:edar_app/utils/mixin_validations.dart';
import 'package:rxdart/rxdart.dart';

mixin PurchaseFieldMixin on ValidationMixin {
  late var _purchaseNoController;
  late var _purchaseDateController;
  late var _batchCodeController;
  late var _supplierController;
  late var _purchaseItemListController;
  late var _totalAmountController;

  init() {
    _purchaseNoController = BehaviorSubject<String>();
    _purchaseDateController = BehaviorSubject<String>();
    _batchCodeController = BehaviorSubject<String>();
    _purchaseItemListController = BehaviorSubject<List<PurchaseItem>>();
    _totalAmountController = BehaviorSubject<double>();
  }

  //set format
  Stream<String> get purchaseNoStream => _purchaseNoController.stream;
  updatePurchaseNo(String fieldValue) {
    if (validTextLength(fieldValue, 4)) {
      _purchaseNoController.sink.add(fieldValue);
    } else {
      _purchaseNoController.sink.addError("Incorrect Format");
    }
  }

  //set format
  Stream<String> get purchaseDateStream => _purchaseDateController.stream;
  updatePurchaseDate(String dateTime) {
    _purchaseDateController.sink.add(dateTime);
  }

  //set format
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
  updateSupplier(Supplier supplier) {
    _supplierController.add.sink(supplier);
  }

  //set format
  Stream<List<PurchaseItem>> get purchaseItemsStream =>
      _purchaseItemListController.stream;
  updatePurchaseItemList(List<PurchaseItem> purchaseItems) {
    _purchaseItemListController.sink.add(purchaseItems);
  }

  List<PurchaseItem>? getPurchaseItems() {
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
    purchaseItems.remove(purchaseItem);
    _purchaseItemListController.sink.add(purchaseItems);
    calculateTotalAmount(purchaseItems);
  }

  //set format
  Stream<double> get totalAmountStream => _totalAmountController.stream;
  updateTotalAmount(double amount) {
    _totalAmountController.sink.add(amount);
  }

  calculateTotalAmount(List<PurchaseItem> purchaseItems) {
    double purchaseTotalAmount =
        purchaseItems.fold(0.0, (sum, element) => sum + element.purchaseAmount);
    print("Total Amount: ${purchaseTotalAmount}");
    updateTotalAmount(purchaseTotalAmount);
  }

  Stream<bool> get saveButtonValid => Rx.combineLatest5(
      purchaseNoStream,
      purchaseDateStream,
      batchCodeStream,
      purchaseItemsStream,
      totalAmountStream,
      (a, b, c, d, e) => true && _purchaseItemListController.value.size > 0);

  Purchase getPurchase(int? purchaseId) {
    return Purchase(
      purchaseId: purchaseId,
      purchaseNo: _purchaseNoController.value,
      purchaseDate: _purchaseDateController.value,
      batchCode: _batchCodeController.value,
      supplier: _supplierController.value,
      purchaseItems: _purchaseItemListController.value,
      totalAmount: _totalAmountController.value,
    );
  }
}