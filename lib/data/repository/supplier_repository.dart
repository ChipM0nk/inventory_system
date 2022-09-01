import 'dart:convert';

import 'package:edar_app/data/model/supplier.dart';
import 'package:edar_app/data/network/network_service.dart';
import 'package:edar_app/routing/route_names.dart';

class SupplierRepository {
  final NetworkService networkService;

  SupplierRepository({required this.networkService});

  Future<List<Supplier>> fetchAll() async {
    final objRaw = await networkService.fetchAll(SuppliersRoute);
    return objRaw.map((e) => Supplier.fromJson(e)).toList();
  }

  Future<bool> addSupplier(Map<String, dynamic> supplierObj) async {
    final isAdded = await networkService.addItem(supplierObj, SuppliersRoute);
    return isAdded;
  }

  Future<bool> deleteSupplier(int supplierId) async {
    final isDeleted =
        await networkService.deleteItem(supplierId, SuppliersRoute);

    return isDeleted;
  }

  Future<bool> udpateSupplier(
      Map<String, dynamic> supplierObj, int supplierId) async {
    final isUpdated = await networkService.udpateItem(
        supplierObj, supplierId, SuppliersRoute);

    return isUpdated;
  }
}
