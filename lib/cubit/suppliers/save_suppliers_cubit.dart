// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:edar_app/common/mixins/error_message_mixin.dart';
import 'package:edar_app/common/mixins/mixin_validations.dart';
import 'package:edar_app/cubit/suppliers/suppliers_field_mixin.dart';
import 'package:edar_app/data/model/supplier.dart';
import 'package:edar_app/data/repository/supplier_repository.dart';
import 'package:meta/meta.dart';

part 'save_suppliers_state.dart';

class SaveSuppliersCubit extends Cubit<SaveSuppliersState>
    with ValidationMixin, SuppliersFieldMixin, ErrorMessageMixin {
  final SupplierRepository supplierRepository = SupplierRepository();
  SaveSuppliersCubit() : super(SaveSuppliersInitial());

  initDialog() {
    init();
    clearError();
    emit(SaveSuppliersInitial());
  }

  void addSupplier() {
    emit(SupplierSaving());
    Map<String, dynamic> supplierObj = getSupplier(null).toJson();
    supplierRepository.addSupplier(supplierObj).then((isAdded) {
      if (isAdded) {
        emit(SupplierSaved());
      } else {
        updateError(null, null);
      }
    }).onError(
      (error, stackTrace) {
        emit(SupplierSavingError());
        updateError('$error', stackTrace);
      },
    );
  }

  void updateSupplier(int supplierId) {
    emit(SupplierSaving());
    Map<String, dynamic> supplierObj = getSupplier(supplierId).toJson();

    supplierRepository
        .udpateSupplier(supplierObj, supplierId!)
        .then((isUpdated) {
      if (isUpdated) {
        emit(SupplierSaved());
      } else {
        updateError(null, null);
      }
    }).onError(
      (error, stackTrace) {
        emit(SupplierSavingError());
        updateError('$error', stackTrace);
      },
    );
  }

  loadSuppliers(Supplier supplier) {
    updateSupplierName(supplier.supplierName);
    updateSupplierAddress(supplier.supplierAddress);
    updateSupplierEmailAddress(supplier.supplierEmailAdd);
    updateSupplierContactNumber(supplier.supplierContactNumber);
  }
}
