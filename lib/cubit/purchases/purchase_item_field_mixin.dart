// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:edar_app/data/model/product.dart';
import 'package:edar_app/data/model/purchase/purchase_item.dart';
import 'package:edar_app/utils/mixin_validations.dart';
import 'package:rxdart/rxdart.dart';

mixin PurchaseItemFieldMixin on ValidationMixin {
  late var _productController;
  late var _purchaseAmountController;
  late var _batchQuantityController;
  late var _itemTotalController;

  initItem() {
    _productController = BehaviorSubject<Product>();
    _purchaseAmountController = BehaviorSubject<double>();
    _batchQuantityController = BehaviorSubject<double>();
    _itemTotalController = BehaviorSubject<double>();
  }

  Stream<Product> get productStream => _productController.stream;
  updateProduct(Product? product) {
    if (product != null) {
      _productController.sink.add(product);
    } else {
      _productController.sink.addError("Please select a product");
    }
  }

  Stream<double> get purchaseAmountStream => _purchaseAmountController.stream;
  updatePurchaseAmount(String fieldValue) {
    if (isFieldDoubleNumeric(fieldValue)) {
      _purchaseAmountController.sink.add(double.parse(fieldValue));
      updateItemTotal();
    } else {
      _purchaseAmountController.sink
          .addError("Please enter valid numeric value");
    }
  }

  Stream<double> get batchQuantityStream => _batchQuantityController.stream;
  updateBatchQuantity(String fieldValue) {
    if (isFieldDoubleNumeric(fieldValue)) {
      _batchQuantityController.sink.add(double.parse(fieldValue));
      updateItemTotal();
    } else {
      _batchQuantityController.sink
          .addError("Please enter valid numeric value");
    }
  }

  Stream<double> get itemTotalStream => _itemTotalController.stream;
  updateItemTotal() {
    double total = (_batchQuantityController.hasValue
            ? _batchQuantityController.value
            : 0.0) *
        (_purchaseAmountController.hasValue
            ? _purchaseAmountController.value
            : 0.0);
    _itemTotalController.sink.add(total);
  }

  Stream<bool> get buttonValidPurchaseItem => Rx.combineLatest4(
      productStream,
      purchaseAmountStream,
      batchQuantityStream,
      itemTotalStream,
      (a, b, c, d) => true);

  PurchaseItem getPurchaseItem(int? purchaseItemId) {
    return PurchaseItem(
      purchaseItemId: purchaseItemId,
      product: _productController.value,
      purchaseAmount: _purchaseAmountController.value,
      batchQuantity: _batchQuantityController.value,
      itemTotalAmount: _itemTotalController.value,
    );
  }
}
