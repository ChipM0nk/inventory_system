// ignore_for_file: must_be_immutable

import 'package:edar_app/cubit/categories/categories_field_mixin.dart';
import 'package:edar_app/data/model/category.dart';
import 'package:edar_app/data/network/network_service.dart';
import 'package:edar_app/data/repository/category_repository.dart';
import 'package:edar_app/common/mixins/error_message_mixin.dart';
import 'package:edar_app/common/mixins/mixin_validations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState>
    with ValidationMixin, ErrorMessageMixin {
  final CategoryRepository categoryRepository =
      CategoryRepository(networkService: NetworkService());

  CategoriesCubit() : super(CategoriesInitial());

  //action methods
  void fetchCategories() {
    categoryRepository
        .fetchAll()
        .then((categories) => {
              emit(CategoriesLoaded(
                categories: categories,
                sortIndex: null,
                sortAscending: true,
              )),
            })
        .onError((error, stackTrace) => updateError('$error', stackTrace));
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

  void deleteCategory(int categoryId) {
    categoryRepository.deleteCategory(categoryId).then((isDeleted) {
      if (isDeleted) {
        emit(CategoryDeleted());
      } else {
        updateError(null, null);
      }
    }).onError((error, stackTrace) => updateError('$error', stackTrace));
  }
}
