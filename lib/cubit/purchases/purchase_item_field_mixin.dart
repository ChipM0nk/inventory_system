// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:edar_app/data/model/product.dart';
import 'package:edar_app/data/model/purchase/purchase_item.dart';
import 'package:edar_app/common/mixins/mixin_validations.dart';
import 'package:rxdart/rxdart.dart';

mixin PurchaseItemFieldMixin on ValidationMixin {
  final _productController = BehaviorSubject<Product>();
  final _purchaseAmountController = BehaviorSubject<double>();
  final _batchQuantityController = BehaviorSubject<double>();
  final _itemTotalController = BehaviorSubject<double>();

  initItem() {
    _productController.sink.addError("");
    _purchaseAmountController.sink.addError("");
    _batchQuantityController.sink.addError("");
    _itemTotalController.sink.addError("");
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
    _itemTotalController.sink.add(total.toPrecision(2));
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
      itemAmount: _purchaseAmountController.value,
      quantity: _batchQuantityController.value,
      itemTotalAmount: _itemTotalController.value,
    );
  }
}
