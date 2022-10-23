import 'dart:convert';

import 'package:edar_app/constants/services.dart';
import 'package:edar_app/data/model/supplier.dart';
import 'package:edar_app/data/network/network_service.dart';

class SupplierRepository {
  final NetworkService networkService;

  SupplierRepository({required this.networkService});

  Future<List<Supplier>> fetchAll() async {
    final objRaw = await networkService.fetchAll(SuppliersService);
    return objRaw.map((e) => Supplier.fromJson(e)).toList();
  }

  Future<bool> addSupplier(Map<String, dynamic> supplierObj) async {
    final isAdded = await networkService.addItem(supplierObj, SuppliersService);
    return isAdded;
  }

  Future<bool> deleteSupplier(int supplierId) async {
    final isDeleted =
        await networkService.deleteItem(supplierId, SuppliersService);

    return isDeleted;
  }

  Future<bool> udpateSupplier(
      Map<String, dynamic> supplierObj, int supplierId) async {
    final isUpdated = await networkService.udpateItem(
        supplierObj, supplierId, SuppliersService);

    return isUpdated;
  }
}
