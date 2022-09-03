// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:edar_app/data/model/invoice_item.dart';
import 'package:edar_app/data/model/product.dart';
import 'package:edar_app/utils/mixin_validations.dart';
import 'package:rxdart/rxdart.dart';

mixin InvoiceItemFieldMixin on ValidationMixin {
  late var _snController;
  late var _productController;
  late var _quantityController;
  late var _priceController;
  late var _amountController;

  init() {
    _snController = BehaviorSubject<String>();
    _productController = BehaviorSubject<Product>();
    _quantityController = BehaviorSubject<double>();
    _priceController = BehaviorSubject<double>();
    _amountController = BehaviorSubject<double>();
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
  updateProduct(Product product) {
    _productController.sink.add(product);
  }

  Stream<double> get quantityStream => _quantityController.stream;
  updateQuantity(String fieldValue) {
    if (isFieldDoubleNumeric(fieldValue)) {
      _quantityController.sink.add(double.parse(fieldValue));
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
  }

  Stream<double> get amountStream => _amountController.stream;
  updateAmount(String fieldValue) {
    if (isFieldDoubleNumeric(fieldValue)) {
      _amountController.sink.add(double.parse(fieldValue));
    } else {
      _amountController.sink.addError("Please enter valid numeric value");
    }
  }

  Stream<bool> get buttonValid => Rx.combineLatest5(snStream, productStream,
      quantityStream, priceStream, amountStream, (a, b, c, d, e) => true);

  InvoiceItem getInvoiceItem(int? invoiceItem) {
    return InvoiceItem(
      invoiceitemId: invoiceItem,
      sn: _snController.value,
      product: _productController.value,
      quantity: _quantityController.value,
      price: _productController.value,
      amount: _amountController.value,
    );
  }
}
