import 'package:edar_app/common/mixins/search_param_mixin.dart';
import 'package:edar_app/cubit/purchases/purchase_field_mixin.dart';
import 'package:edar_app/cubit/purchases/purchase_item_field_mixin.dart';
import 'package:edar_app/data/model/purchase/purchase.dart';
import 'package:edar_app/data/repository/purchase_repository.dart';
import 'package:edar_app/common/mixins/error_message_mixin.dart';
import 'package:edar_app/common/mixins/mixin_validations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'purchase_state.dart';

// ignore: must_be_immutable
class PurchaseCubit extends Cubit<PurchaseState>
    with
        ValidationMixin,
        PurchaseFieldMixin,
        PurchaseItemFieldMixin,
        ErrorMessageMixin,
        SearchParamMixin {
  final PurchaseRepository purchaseRepository;

  void reset() {
    emit(PurchaseInitial());
  }

  PurchaseCubit({required this.purchaseRepository}) : super(PurchaseInitial());

  void fetchPurchases() {
    purchaseRepository.fetchAll().then((purchase) => {
          emit(PurchaseLoaded(
            purchases: purchase,
            sortIndex: null,
            sortAscending: true,
          )),
        });
  }

  void fetchPurchasesWithParam() {
    emit(PurchaseLoading());
    Map<String, dynamic> paramObj = getParam()!.toJson();
    purchaseRepository
        .fetchWithParam(paramObj)
        .then((purchases) => {
              emit(PurchaseLoaded(
                purchases: purchases,
                sortIndex: null,
                sortAscending: true,
              )),
            })
        .onError((error, stackTrace) => updateError('$error', stackTrace));
  }

  void sortPurchase<T>(Comparable<T> Function(Purchase) getField, int sortIndex,
      bool ascending) {
    final currentState = state;
    if (currentState is PurchaseLoaded) {
      final purchase = currentState.purchases;
      final filteredData = currentState.filteredData;

      final data = filteredData ?? purchase;
      data.sort((a, b) {
        final aValue = getField(a);
        final bValue = getField(b);
        return ascending
            ? Comparable.compare(aValue, bValue)
            : Comparable.compare(bValue, aValue);
      });
      emit(PurchaseLoaded(
          filteredData: data,
          purchases: purchase,
          sortIndex: sortIndex,
          sortAscending: ascending));
    }
  }

  void addPurchase() {
    Map<String, dynamic> purchaseObj = getPurchase(null).toJson();

    purchaseRepository.addPurchase(purchaseObj).then((isAdded) {
      if (isAdded) {
        // fetchPurchase();
        emit(PurchaseAdded());
      } else {
        updateError(null, null);
      }
    }).onError((error, stackTrace) => updateError('$error', stackTrace));
  }

  void updatePurchase(int purchaseId) {
    Map<String, dynamic> purchaseObj = getPurchase(purchaseId).toJson();
    print("Update ::: ${purchaseObj}");

    purchaseRepository
        .udpatePurchase(purchaseObj, purchaseId)
        .then((isUpdated) {
      if (isUpdated) {
        // fetchPurchase();
        emit(PurchaseUpdated());
        fetchPurchases();
      } else {
        updateError(null, null);
      }
    }).onError((error, stackTrace) => updateError('$error', stackTrace));
  }

  void deletePurchase(int purchaseId) {
    purchaseRepository.deletePurchase(purchaseId).then((isDeleted) {
      if (isDeleted) {
        emit(PurchaseDeleted());
        fetchPurchases();
      } else {
        updateError(null, null);
      }
    }).onError((error, stackTrace) => updateError('$error', stackTrace));
  }

  void searchPurchase(String searchText) {
    final currentState = state;
    if (currentState is PurchaseLoaded) {
      final data = currentState.purchases;
      if (searchText.isEmpty) {
        emit(PurchaseLoaded(purchases: data, sortAscending: false));
      } else {
        final filteredData = data
            .where((purchase) => purchase.batchCode.contains(searchText))
            .toList();
        emit(PurchaseLoaded(
            filteredData: filteredData, purchases: data, sortAscending: true));
      }
    }
  }

  loadPurchase(Purchase purchase) {
    updatePurchaseNo(purchase.purchaseNo);
    updatePurchaseDate(purchase.purchaseDate);
    updatePurchaseItemList(purchase.purchaseItems);
    updateBatchCode(purchase.batchCode);
    updateTotalAmount(purchase.totalAmount);
  }
}
