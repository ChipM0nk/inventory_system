// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:edar_app/data/model/param.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

@immutable
mixin InvoiceSearchParamMixin {
  final _dateFromController = BehaviorSubject<String>();
  final _dateToController = BehaviorSubject<String>();
  static const dateFormat = 'dd-MMM-yy';
  initSearch() {
    _dateFromController.sink.addError("");
    _dateToController.sink.addError("");
  }

  Stream<String> get dateFromStream => _dateFromController.stream;
  updateDateFrom(String dateTime) {
    _dateFromController.sink.add(dateTime);
  }

  Stream<String> get dateToStream => _dateToController.stream;
  updateDateTo(String dateTime) {
    _dateToController.sink.add(dateTime);
  }

  bool isDateRangeValid() {
    try {
      DateTime dateFrom =
          DateFormat(dateFormat).parse(_dateFromController.value);
      DateTime dateTo = DateFormat(dateFormat).parse(_dateToController.value);
      if (dateFrom.isAfter(dateTo)) {
        print("invalid date");
        _dateToController.sink.addError("Invalid date");
        return false;
      }
      return true;
      // ignore: empty_catches
    } catch (e) {}

    return false;
  }

  Stream<bool> get filterButtonValid => Rx.combineLatest2(
      dateFromStream, dateToStream, (a, b) => true && isDateRangeValid());

  Param? getParam() {
    try {
      if (!_dateFromController.hasValue || !_dateToController.hasValue) {
        print("no value"); //TODO make it work
        return null;
      }
      return Param(
          dateFrom: _dateFromController.value, dateTo: _dateToController.value);
    } catch (e) {
      return null;
    }
  }
}
