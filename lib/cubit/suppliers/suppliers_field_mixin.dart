import 'package:edar_app/data/model/supplier.dart';
import 'package:edar_app/utils/mixin_validations.dart';
import 'package:rxdart/rxdart.dart';

mixin SuppliersFieldMixin on ValidationMixin {
  //streams and validations

  final _supplierNameController = BehaviorSubject<String>();
  final _supplierAddressController = BehaviorSubject<String>();
  final _supplierEmailAddController = BehaviorSubject<String>();
  final _supplierContactNumController = BehaviorSubject<String>();

  init() {
    _supplierNameController.sink.addError("");
    _supplierAddressController.sink.addError("");
    _supplierEmailAddController.sink.addError("");
    _supplierContactNumController.sink.addError("");
  }

  Stream<String> get supplierNameStream => _supplierNameController.stream;
  updateSupplierName(String fieldValue) {
    if (validTextLength(fieldValue, 2)) {
      _supplierNameController.sink.add(fieldValue);
    } else {
      _supplierNameController.sink
          .addError("Please enter text with length greater than 2");
    }
  }

  Stream<String> get supplierAddressStream => _supplierAddressController.stream;
  updateSupplierAddress(String fieldValue) {
    if (validTextLength(fieldValue, 4)) {
      _supplierAddressController.sink.add(fieldValue);
    } else {
      _supplierAddressController.sink
          .addError("Please enter text with length greater than 4");
    }
  }

  Stream<String> get supplierEmailAddStream =>
      _supplierEmailAddController.stream;
  updateSupplierEmailAddress(String fieldValue) {
    if (validTextLength(fieldValue, 4)) {
      //create email add validator
      _supplierEmailAddController.sink.add(fieldValue);
    } else {
      _supplierEmailAddController.sink
          .addError("Please enter text with length greater than 4");
    }
  }

  Stream<String> get supplierContactNumStream =>
      _supplierContactNumController.stream;
  updateSupplierContactNumber(String fieldValue) {
    if (validTextLength(fieldValue, 10) && isFieldNumeric(fieldValue)) {
      _supplierContactNumController.sink.add(fieldValue);
    } else {
      _supplierContactNumController.sink
          .addError("Please enter numeric value with length greater than 10");
    }
  }

  Stream<bool> get buttonValid => Rx.combineLatest4(
      supplierNameStream,
      supplierAddressStream,
      supplierEmailAddStream,
      supplierContactNumStream,
      (a, b, c, d) => true);

  Supplier getSupplier(int? supplierId) {
    return Supplier(
      supplierId: supplierId,
      supplierName: _supplierNameController.value,
      supplierAddress: _supplierAddressController.value,
      supplierEmailAdd: _supplierEmailAddController.value,
      supplierContactNumber: _supplierContactNumController.value,
    );
  }
}
