// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:edar_app/data/model/invoice/invoice_item.dart';
import 'package:edar_app/data/model/product.dart';
import 'package:edar_app/utils/mixin_validations.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

@immutable
mixin InvoiceItemFieldMixin on ValidationMixin {
  final _snController = BehaviorSubject<String>();
  final _productController = BehaviorSubject<Product>();
  final _quantityController = BehaviorSubject<double>();
  final _priceController = BehaviorSubject<double>();
  final _invoiceItemAmountController = BehaviorSubject<double>();

  initItem() {
    _snController.sink.addError("");
    _productController.sink.addError("");
    _quantityController.sink.addError("");
    _priceController.sink.addError("");
    _invoiceItemAmountController.sink.addError("");
  }

  Stream<String> get snStream => _snController.stream;
  updateSn(String fieldValue) {
    if (validTextLength(fieldValue, 4)) {
      _snController.sink.add(fieldValue);
    } else {
      _snController.sink
          .addError("Please enter text with length greater than 4");
    }
  }

  Stream<Product> get productStream => _productController.stream;
  updateProduct(Product? product) {
    if (product != null) {
      _productController.sink.add(product);
    } else {
      _productController.sink.addError("Please select a product");
    }
  }

  Product? getProduct() {
    return _productController.hasValue ? _productController.value : null;
  }

  Stream<double> get quantityStream => _quantityController.stream;
  updateQuantity(String fieldValue) {
    if (isFieldDoubleNumeric(fieldValue)) {
      double quantity = double.parse(fieldValue);
      _quantityController.sink.add(quantity);

      Product product = _productController.value;
      if (product.currentStock < quantity) {
        _quantityController.sink.addError("Not enough stock");
      } else {
        updateInvoiceItemAmount();
      }
    } else {
      _quantityController.sink.addError("Please enter valid numeric value");
    }
  }

  Stream<double> get priceStream => _priceController.stream;
  updatePrice(String fieldValue) {
    if (isFieldDoubleNumeric(fieldValue)) {
      _priceController.sink.add(double.parse(fieldValue));
    } else {
      _priceController.sink.addError("Please enter valid numeric value");
    }
    updateInvoiceItemAmount();
  }

  Stream<double> get invoiceItemAmountStream =>
      _invoiceItemAmountController.stream;
  updateInvoiceItemAmount() {
    double itemAmount =
        (_quantityController.hasValue ? _quantityController.value : 0.0) *
            (_priceController.hasValue ? _priceController.value : 0.0);
    _invoiceItemAmountController.sink.add(itemAmount.toPrecision(2));
  }

  Stream<bool> get buttonValidInvoiceItem => Rx.combineLatest4(
      productStream,
      quantityStream,
      priceStream,
      invoiceItemAmountStream,
      (a, b, c, d) =>
          true &&
          _productController.value.currentStock >= _quantityController.value);

  InvoiceItem getInvoiceItem(int? invoiceItem) {
    return InvoiceItem(
      invoiceitemId: invoiceItem,
      sn: 1,
      product: _productController.value,
      quantity: _quantityController.value,
      price: _priceController.value,
      totalAmount: _invoiceItemAmountController.value,
    );
  }
}
