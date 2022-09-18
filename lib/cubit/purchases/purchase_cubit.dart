import 'package:edar_app/cubit/purchases/purchase_field_mixin.dart';
import 'package:edar_app/cubit/purchases/purchase_item_field_mixin.dart';
import 'package:edar_app/data/model/purchase/purchase.dart';
import 'package:edar_app/data/repository/purchase_repository.dart';
import 'package:edar_app/utils/mixin_validations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'purchase_state.dart';

class PurchaseCubit extends Cubit<PurchaseState>
    with ValidationMixin, PurchaseFieldMixin, PurchaseItemFieldMixin {
  final PurchaseRepository purchaseRepository;

  PurchaseCubit({required this.purchaseRepository}) : super(PurchaseInitial());

  void fetchPurchase() {
    purchaseRepository.fetchAll().then((purchase) => {
          emit(PurchaseLoaded(
            purchases: purchase,
            sortIndex: null,
            sortAscending: true,
          )),
        });
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
    emit(AddingPurchase());

    Map<String, dynamic> purchaseObj = getPurchase(null).toJson();

    print("Add suppplier :::: ${purchaseObj}");
    purchaseRepository.addPurchase(purchaseObj).then((isAdded) {
      if (isAdded) {
        // fetchPurchase();
        emit(PurchaseAdded());
        fetchPurchase();
      } else {
        emit(PurchasetateError());
      }
    });
  }

  void updatePurchase(int purchaseId) {
    emit(UpdatingPurchase());

    Map<String, dynamic> purchaseObj = getPurchase(purchaseId).toJson();
    print("Update ::: ${purchaseObj}");

    purchaseRepository
        .udpatePurchase(purchaseObj, purchaseId)
        .then((isUpdated) {
      if (isUpdated) {
        // fetchPurchase();
        emit(PurchaseUpdated());
        fetchPurchase();
      } else {
        emit(PurchasetateError());
      }
    });
  }

  void deletePurchase(int purchaseId) {
    emit(DeletingPurchase());

    purchaseRepository.deletePurchase(purchaseId).then((isDeleted) {
      if (isDeleted) {
        emit(PurchaseDeleted());
        fetchPurchase();
      } else {
        emit(PurchasetateError());
      }
    });
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
