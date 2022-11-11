// ignore_for_file: depend_on_referenced_packages, must_be_immutable

import 'package:bloc/bloc.dart';
import 'package:edar_app/common/mixins/error_message_mixin.dart';
import 'package:edar_app/common/mixins/mixin_validations.dart';
import 'package:edar_app/cubit/categories/categories_field_mixin.dart';
import 'package:edar_app/data/model/category.dart';
import 'package:edar_app/data/network/network_service.dart';
import 'package:edar_app/data/repository/category_repository.dart';
import 'package:meta/meta.dart';

part 'add_categories_state.dart';

class SaveCategoriesCubit extends Cubit<SaveCategoriesState>
    with ValidationMixin, CategoriesFieldMixin, ErrorMessageMixin {
  final CategoryRepository categoryRepository =
      CategoryRepository(networkService: NetworkService());
  SaveCategoriesCubit() : super(SaveCategoriesInitial());

  loadCategory(Category category) {
    updateCategoryCode(category.categoryCode);
    updateCategoryName(category.categoryName);
  }

  initDialog() {
    init();
    clearError();
    emit(SaveCategoriesInitial());
  }

  void addCategory() {
    emit(CategorySaving());

    Category category = getCategory(null);

    Map<String, dynamic> categoryObj = category.toJson();
    categoryRepository.addCategory(categoryObj).then((isAdded) {
      if (isAdded) {
        emit(CategorySaved());
      } else {
        updateError(null, null);
        emit(CategorySavingError());
      }
    }).onError(
      (error, stackTrace) {
        emit(CategorySavingError());
        updateError('$error', stackTrace);
      },
    );
  }

  void updateCategory(int categoryId) {
    emit(CategoryUpdating());
    Category category = getCategory(categoryId);
    Map<String, dynamic> categoryObj = category.toJson();
    categoryRepository
        .udpateCategory(categoryObj, category.categoryId!)
        .then((isUpdated) {
      if (isUpdated) {
        emit(CategoryUpdated());
      } else {
        updateError(null, null);
      }
    }).onError((error, stackTrace) => updateError('$error', stackTrace));
  }
}
