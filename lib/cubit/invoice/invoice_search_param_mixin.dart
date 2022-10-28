// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:edar_app/data/model/param.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

mixin InvoiceSearchParamMixin {
  late var _dateFromController;
  late var _dateToController;
  static const dateFormat = 'dd-MMM-yy';
  initSearch() {
    _dateFromController = BehaviorSubject<String>();
    _dateToController = BehaviorSubject<String>();
  }

  Stream<String> get dateFromStream => _dateFromController.stream;
  updateDateFrom(String dateTime) {
    _dateFromController.sink.add(dateTime);
  }

  Stream<String> get dateToStream => _dateToController.stream;
  updateDateTo(String dateTime) {
    DateTime dateFrom =
        DateFormat(dateFormat).parse(_dateFromController.valueOrNull);
    DateTime dateTo = DateFormat(dateFormat).parse(dateTime);
    if (dateFrom.isAfter(dateTo)) {
      _dateFromController.sink.error("Invalid date");
    }
    _dateToController.sink.add(dateTime);
  }

  Stream<bool> get filterButtonValid =>
      Rx.combineLatest2(dateFromStream, dateToStream, (a, b) => true);

  Param getParam() {
    return Param(
        dateFrom: _dateFromController.valueOrNull,
        dateTo: _dateToController.valueOrNull);
  }
}
