// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:edar_app/data/model/category.dart';
import 'package:edar_app/data/model/product.dart';
import 'package:edar_app/data/model/supplier.dart';
import 'package:edar_app/utils/mixin_validations.dart';
import 'package:rxdart/rxdart.dart';

mixin ProductsFieldMixin on ValidationMixin {
  //streams and validations

  late var _productNameController;
  late var _productCodeController;
  late var _productDescriptionController;
  late var _productPriceController;
  late var _productQuantityController;
  late var _productUnitController;
  late var _productSupplierController;
  late var _productCategoryController;

  init() {
    print("init");
    _productNameController = BehaviorSubject<String>();
    _productCodeController = BehaviorSubject<String>();
    _productDescriptionController = BehaviorSubject<String>();
    _productPriceController = BehaviorSubject<double>();
    _productQuantityController = BehaviorSubject<double>();
    _productUnitController = BehaviorSubject<String>();
    _productSupplierController = BehaviorSubject<Supplier>();
    _productCategoryController = BehaviorSubject<Category>();
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
