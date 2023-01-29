import 'package:edar_app/common/mixins/mixin_validations.dart';
import 'package:edar_app/data/model/invoice/proforma.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

@immutable
mixin ProformaFieldMixin on ValidationMixin {
  final _deliveredByController = BehaviorSubject<String>();
  final _contactPersonController = BehaviorSubject<String>();
  final _deliveryDateController = BehaviorSubject<String>();
  final _dueDateController = BehaviorSubject<String>();
  final _shippingMethodController = BehaviorSubject<String>();

  initProforma() {
    _deliveredByController.sink.addError("");
    _contactPersonController.sink.addError("");
    _deliveryDateController.sink.addError("");
    _dueDateController.sink.addError("");
    _shippingMethodController.sink.add("Pick-up");
  }

  String getShippingMethod() {
    return _shippingMethodController.value;
  }

  Stream<String> get deliveredByStream => _deliveredByController.stream;
  updateDeliveredBy(String fieldValue) {
    if (validTextLength(fieldValue, 4)) {
      _deliveredByController.sink.add(fieldValue);
    } else {
      _deliveredByController.sink
          .addError("Please enter text with length greater than 4");
    }
  }

  Stream<String> get contactPersonStream => _contactPersonController.stream;
  updateContactPerson(String fieldValue) {
    if (validTextLength(fieldValue, 4)) {
      _contactPersonController.sink.add(fieldValue);
    } else {
      _contactPersonController.sink
          .addError("Please enter text with length greater than 4");
    }
  }

  Stream<String> get shippingMethodStream => _shippingMethodController.stream;
  updateShippingMethod(String value) {
    _shippingMethodController.sink.add(value);
  }

  Stream<String> get deliveryDateStream => _deliveryDateController.stream;
  updateDeliveryDate(String dateTime) {
    _deliveryDateController.sink.add(dateTime);
  }

  Stream<String> get dueDateStream => _dueDateController.stream;
  updateDueDate(String dateTime) {
    _dueDateController.sink.add(dateTime);
  }

  Proforma getProforma(int? deliveryId) {
    return Proforma(
      contactPerson: _contactPersonController.valueOrNull,
      deliveredBy: _deliveredByController.valueOrNull,
      dueDate: _dueDateController.valueOrNull,
      deliveryDate: _deliveryDateController.valueOrNull,
      shippingMethod: _shippingMethodController.value,
    );
  }
}
