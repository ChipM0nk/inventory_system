import 'package:edar_app/cubit/categories/categories_field_mixin.dart';
import 'package:edar_app/data/model/category.dart';
import 'package:edar_app/data/repository/category_repository.dart';
import 'package:edar_app/utils/mixin_validations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'categories_state.dart';

@immutable
class CategoriesCubit extends Cubit<CategoriesState>
    with ValidationMixin, CategoriesFieldMixin {
  final CategoryRepository categoryRepository;

  CategoriesCubit({required this.categoryRepository})
      : super(CategoriesInitial());

  loadCategory(Category category) {
    updateCategoryCode(category.categoryCode);
    updateCategoryName(category.categoryName);
  }

  //action methods
  void fetchCategories() {
    print("Fetch categories");
    categoryRepository
        .fetchAll()
        .then((categories) => {
              emit(CategoriesLoaded(
                categories: categories,
                sortIndex: null,
                sortAscending: true,
              )),
            })
        .onError((error, stackTrace) => updateError('$error'));
  }

  void sortCategories<T>(Comparable<T> Function(Category) getField,
      int sortIndex, bool ascending) {
    final currentState = state;
    if (currentState is CategoriesLoaded) {
      final categories = currentState.categories;
      final filteredData = currentState.filteredData;

      final data = filteredData ?? categories;
      data.sort((a, b) {
        final aValue = getField(a);
        final bValue = getField(b);
        return ascending
            ? Comparable.compare(aValue, bValue)
            : Comparable.compare(bValue, aValue);
      });
      emit(CategoriesLoaded(
          filteredData: data,
          categories: categories,
          sortIndex: sortIndex,
          sortAscending: ascending));
    }
  }

  void addCategory() {
    // emit(AddingCategory());

    Category category = getCategory(null);

    Map<String, dynamic> categoryObj = category.toJson();
    categoryRepository.addCategory(categoryObj).then((isAdded) {
      if (isAdded) {
        // fetchCategories();
        emit(CategoryAdded());
        fetchCategories();
      } else {
        updateError(null);
      }
    }).onError(
      (error, stackTrace) {
        print("Error message : ${error}");
        updateError('$error');
      },
    );
  }

  void updateCategory(int categoryId) {
    Category category = getCategory(categoryId);
    Map<String, dynamic> categoryObj = category.toJson();
    categoryRepository
        .udpateCategory(categoryObj, category.categoryId!)
        .then((isUpdated) {
      if (isUpdated) {
        // fetchCategories();
        emit(CategoryUpdated());
        fetchCategories();
      } else {
        updateError(null);
      }
    }).onError((error, stackTrace) => updateError('$error'));
  }

  void deleteCategory(int categoryId) {
    categoryRepository.deleteCategory(categoryId).then((isDeleted) {
      if (isDeleted) {
        emit(CategoryDeleted());
        fetchCategories();
      } else {
        updateError(null);
      }
    }).onError((error, stackTrace) => updateError('$error'));
  }

  void searchCategory(String searchText) {
    final currentState = state;
    if (currentState is CategoriesLoaded) {
      final data = currentState.categories;
      if (searchText.isEmpty) {
        emit(CategoriesLoaded(categories: data, sortAscending: false));
      } else {
        final filteredData = data
            .where((cat) =>
                cat.categoryCode
                    .toLowerCase()
                    .contains(searchText.toLowerCase()) ||
                cat.categoryName
                    .toLowerCase()
                    .contains(searchText.toLowerCase()))
            .toList();
        emit(CategoriesLoaded(
            filteredData: filteredData, categories: data, sortAscending: true));
      }
    }
  }
}
