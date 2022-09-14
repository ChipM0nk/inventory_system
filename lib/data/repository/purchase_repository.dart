import 'package:edar_app/data/model/purchase/purchase.dart';
import 'package:edar_app/data/network/network_service.dart';
import 'package:edar_app/routing/route_names.dart';

class PurchaseRepository {
  final NetworkService networkService;

  PurchaseRepository({required this.networkService});

  Future<List<Purchase>> fetchAll() async {
    final objRaw = await networkService.fetchAll(PurchasesRoute);

    return objRaw.map((e) => Purchase.fromJson(e)).toList();
  }

  Future<bool> addPurchase(Map<String, dynamic> purchaseObj) async {
    final isAdded = await networkService.addItem(purchaseObj, PurchasesRoute);

    return isAdded;
  }

  Future<bool> deletePurchase(int purchaseId) async {
    final isDeleted =
        await networkService.deleteItem(purchaseId, PurchasesRoute);

    return isDeleted;
  }

  Future<bool> udpatePurchase(
      Map<String, dynamic> purchaseObj, int purchaseId) async {
    final isUpdated = await networkService.udpateItem(
        purchaseObj, purchaseId, PurchasesRoute);

    return isUpdated;
  }
}
