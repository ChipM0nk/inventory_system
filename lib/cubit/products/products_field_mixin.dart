// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:edar_app/data/model/category.dart';
import 'package:edar_app/data/model/product.dart';
import 'package:edar_app/data/model/supplier.dart';
import 'package:edar_app/utils/mixin_validations.dart';
import 'package:rxdart/rxdart.dart';

mixin ProductsFieldMixin on ValidationMixin {
  //streams and validations

  final _productNameController = BehaviorSubject<String>();
  final _productCodeController = BehaviorSubject<String>();
  final _productDescriptionController = BehaviorSubject<String>();
  final _productPriceController = BehaviorSubject<double>();
  final _productQuantityController = BehaviorSubject<double>();
  final _productUnitController = BehaviorSubject<String>();
  final _productSupplierController = BehaviorSubject<Supplier>();
  final _productCategoryController = BehaviorSubject<Category>();

  init() {
    print("init");
    _productNameController.sink.addError("");
    _productCodeController.sink.addError("");
    _productDescriptionController.sink.addError("");
    _productPriceController.sink.addError("");
    _productQuantityController.sink.addError("");
    _productUnitController.sink.addError("");
    _productSupplierController.sink.addError("");
    _productCategoryController.sink.addError("");
  }

  Stream<String> get productNameStream => _productNameController.stream;
  updateProductName(String fieldValue) {
    if (validTextLength(fieldValue, 4)) {
      _productNameController.sink.add(fieldValue);
    } else {
      _productNameController.sink
          .addError("Please enter text with length greater than 4");
    }
  }

  Stream<String> get productCodeStream => _productCodeController.stream;
  updateProductCode(String fieldValue) {
    if (validTextLength(fieldValue, 3)) {
      _productCodeController.sink.add(fieldValue);
    } else {
      _productCodeController.sink
          .addError("Please enter text with length greater than 3");
    }
  }

  Stream<String> get productDescriptionStream =>
      _productDescriptionController.stream;
  updateProductDecription(String fieldValue) {
    if (validTextLength(fieldValue, 4)) {
      _productDescriptionController.sink.add(fieldValue);
    } else {
      _productDescriptionController.sink
          .addError("Please enter text with length greater than 4");
    }
  }

  Stream<double> get productPriceStream => _productPriceController.stream;
  updateProductPrice(String fieldValue) {
    if (isFieldDoubleNumeric(fieldValue)) {
      _productPriceController.sink.add(double.parse(fieldValue));
    } else {
      _productPriceController.sink.addError("Please enter numeric value");
    }
  }

  Stream<double> get productQuantityStream => _productQuantityController.stream;
  updateProductQuantity(String fieldValue) {
    if (isFieldDoubleNumeric(fieldValue)) {
      _productQuantityController.sink.add(double.parse(fieldValue));
    } else {
      _productQuantityController.sink.addError("Please enter numeric value");
    }
  }

  Stream<String> get productUnitStream => _productUnitController.stream;
  updateProductUnit(String fieldValue) {
    if (validTextLength(fieldValue, 2)) {
      _productUnitController.sink.add(fieldValue);
    } else {
      _productUnitController.sink
          .addError("Please enter text with length greater than 2");
    }
  }

  Stream<Supplier> get productSupplierStream =>
      _productSupplierController.stream;
  updateProductSupplier(Supplier supplier) {
    _productSupplierController.sink.add(supplier);
  }

  Supplier? getSupplier() {
    return _productSupplierController.value;
  }

  Stream<Category> get productCategoryStream =>
      _productCategoryController.stream;
  updateProductCategory(Category category) async {
    _productCategoryController.sink.add(category);
  }

  Category? getCategory() {
    return _productCategoryController.hasValue
        ? _productCategoryController.value
        : null;
  }

  Stream<bool> get buttonValid => Rx.combineLatest7(
      productCodeStream,
      productNameStream,
      productDescriptionStream,
      productUnitStream,
      productPriceStream,
      productSupplierStream,
      productCategoryStream,
      (a, b, c, d, e, f, g) => true);

  Product getProduct(int? productId) {
    return Product(
      productId: productId,
      productCode: _productCodeController.value,
      productName: _productNameController.value,
      productDescription: _productDescriptionController.value,
      productPrice: _productPriceController.value,
      currentStock: _productQuantityController.value,
      unit: _productUnitController.value,
      supplier: _productSupplierController.value,
      category: _productCategoryController.value,
    );
  }
}
