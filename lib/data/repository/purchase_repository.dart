import 'package:edar_app/constants/services.dart';
import 'package:edar_app/data/model/purchase/purchase.dart';
import 'package:edar_app/data/network/network_service.dart';

class PurchaseRepository {
  final NetworkService networkService;

  PurchaseRepository({required this.networkService});

  Future<List<Purchase>> fetchAll() async {
    final objRaw = await networkService.fetchAll(PurchasesService);

    return objRaw.map((e) => Purchase.fromJson(e)).toList();
  }

  Future<bool> addPurchase(Map<String, dynamic> purchaseObj) async {
    final isAdded = await networkService.addItem(purchaseObj, PurchasesService);

    return isAdded;
  }

  Future<bool> deletePurchase(int purchaseId) async {
    final isDeleted =
        await networkService.deleteItem(purchaseId, PurchasesService);

    return isDeleted;
  }

  Future<bool> udpatePurchase(
      Map<String, dynamic> purchaseObj, int purchaseId) async {
    final isUpdated = await networkService.udpateItem(
        purchaseObj, purchaseId, PurchasesService);

    return isUpdated;
  }
}
