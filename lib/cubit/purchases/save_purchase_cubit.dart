// ignore_for_file: must_be_immutable

import 'package:bloc/bloc.dart';
import 'package:edar_app/common/mixins/error_message_mixin.dart';
import 'package:edar_app/common/mixins/mixin_validations.dart';
import 'package:edar_app/cubit/purchases/purchase_field_mixin.dart';
import 'package:edar_app/cubit/purchases/purchase_item_field_mixin.dart';
import 'package:edar_app/data/model/purchase/purchase.dart';
import 'package:edar_app/data/repository/purchase_repository.dart';
import 'package:flutter/material.dart';

part 'save_purchase_state.dart';

class SavePurchaseCubit extends Cubit<SavePurchaseState>
    with
        ValidationMixin,
        PurchaseFieldMixin,
        PurchaseItemFieldMixin,
        ErrorMessageMixin {
  final PurchaseRepository purchaseRepository = PurchaseRepository();

  SavePurchaseCubit() : super(SavePurchaseInitial());

  initDialog() {
    init();
    clearError();
    emit(SavePurchaseInitial());
  }

  void reset() {
    emit(SavePurchaseInitial());
  }

  void addPurchase() {
    emit(PurchaseSaving());
    Map<String, dynamic> purchaseObj = getPurchase(null).toJson();

    purchaseRepository.addPurchase(purchaseObj).then((isAdded) {
      if (isAdded) {
        emit(PurchaseSaved());
      } else {
        emit(PurchaseSavingError());
        updateError(null, null);
      }
    }).onError(
      (error, stackTrace) {
        emit(PurchaseSavingError());
        updateError('$error', stackTrace);
      },
    );
  }

  void updatePurchase(int purchaseId) {
    emit(PurchaseSaving());
    Map<String, dynamic> purchaseObj = getPurchase(purchaseId).toJson();

    purchaseRepository
        .udpatePurchase(purchaseObj, purchaseId)
        .then((isUpdated) {
      if (isUpdated) {
        emit(PurchaseSaved());
      } else {
        emit(PurchaseSavingError());
        updateError(null, null);
      }
    }).onError(
      (error, stackTrace) {
        emit(PurchaseSavingError());
        updateError('$error', stackTrace);
      },
    );
  }

  void voidPurchase(int purchaseId) {
    emit(PurchaseVoiding());
    purchaseRepository.voidPurchase(purchaseId).then((isVoided) {
      if (isVoided) {
        emit(PurchaseVoided());
      } else {
        emit(PurchaseVoidingError());
        updateError(null, null);
      }
    }).onError(
      (error, stackTrace) {
        emit(PurchaseVoidingError());
        updateError('$error', stackTrace);
      },
    );
  }

  loadPurchase(Purchase purchase) {
    updatePurchaseNo(purchase.purchaseNo);
    updatePurchaseDate(purchase.purchaseDate);
    updatePurchaseItemList(purchase.purchaseItems);
    updateBatchCode(purchase.batchCode);
    updateTotalAmount(purchase.totalAmount);
  }
}
