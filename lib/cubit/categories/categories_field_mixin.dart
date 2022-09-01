// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:edar_app/data/model/category.dart';
import 'package:edar_app/utils/mixin_validations.dart';
import 'package:rxdart/rxdart.dart';

mixin CategoriesFieldMixin on ValidationMixin {
  //streams and validations
  late var _categoryCodeController;
  late var _categoryNameController;

  init() {
    print("init"); //TODO Change this later to proper dispose
    _categoryCodeController = BehaviorSubject<String>();
    _categoryNameController = BehaviorSubject<String>();
  }

  Stream<String> get categoryCodeStream => _categoryCodeController.stream;
  updateCategoryCode(String fieldValue) {
    if (validTextLength(fieldValue, 4)) {
      _categoryCodeController.sink.add(fieldValue);
    } else {
      _categoryCodeController.sink
          .addError("Please enter text with length greater than 4");
    }
  }

  Stream<String> get categoryNameStream => _categoryNameController.stream;

  updateCategoryName(String fieldValue) {
    if (validTextLength(fieldValue, 4)) {
      _categoryNameController.sink.add(fieldValue);
    } else {
      _categoryNameController.sink
          .addError("Please enter text with length greater than 4");
    }
  }

  Stream<bool> get buttonValid =>
      Rx.combineLatest2(categoryCodeStream, categoryNameStream, (a, b) => true);

  Category getCategory(int? categoryId) {
    return Category(
        categoryId: categoryId,
        categoryCode: _categoryCodeController.value,
        categoryName: _categoryNameController.value);
  }
}
