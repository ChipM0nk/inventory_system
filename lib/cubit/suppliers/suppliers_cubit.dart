import 'dart:io';

import 'package:edar_app/cubit/suppliers/suppliers_field_mixin.dart';
import 'package:edar_app/data/model/supplier.dart';
import 'package:edar_app/data/repository/supplier_repository.dart';
import 'package:edar_app/common/mixins/error_message_mixin.dart';
import 'package:edar_app/common/mixins/mixin_validations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'suppliers_state.dart';

class SuppliersCubit extends Cubit<SuppliersState>
    with ValidationMixin, SuppliersFieldMixin, ErrorMessageMixin {
  final SupplierRepository supplierRepository = SupplierRepository();

  SuppliersCubit() : super(SuppliersInitial());

  void fetchSuppliers() {
    supplierRepository
        .fetchAll()
        .then((suppliers) => {
              emit(SuppliersLoaded(
                suppliers: suppliers,
                sortIndex: null,
                sortAscending: true,
              )),
            })
        .onError((error, stackTrace) => updateError('$error', stackTrace));
  }

  void sortSuppliers<T>(Comparable<T> Function(Supplier) getField,
      int sortIndex, bool ascending) {
    final currentState = state;
    if (currentState is SuppliersLoaded) {
      final suppliers = currentState.suppliers;
      final filteredData = currentState.filteredData;

      final data = filteredData ?? suppliers;
      data.sort((a, b) {
        final aValue = getField(a);
        final bValue = getField(b);
        return ascending
            ? Comparable.compare(aValue, bValue)
            : Comparable.compare(bValue, aValue);
      });
      emit(SuppliersLoaded(
          filteredData: data,
          suppliers: suppliers,
          sortIndex: sortIndex,
          sortAscending: ascending));
    }
  }

  void searchSupplier(String searchText) {
    final currentState = state;
    if (currentState is SuppliersLoaded) {
      final data = currentState.suppliers;
      if (searchText.isEmpty) {
        emit(SuppliersLoaded(suppliers: data, sortAscending: false));
      } else {
        final filteredData =
            data.where((cat) => cat.supplierName.contains(searchText)).toList();
        emit(SuppliersLoaded(
            filteredData: filteredData, suppliers: data, sortAscending: true));
      }
    }
  }

  void deleteSupplier(int supplierId) {
    supplierRepository.deleteSupplier(supplierId).then((isDeleted) {
      if (isDeleted) {
        emit(SupplierDeleted());
        fetchSuppliers();
      } else {
        updateError(null, null);
      }
    }).onError(
      (error, stackTrace) {
        print("Error message : ${error}");
        updateError('$error', stackTrace);
      },
    );
  }
}
