import 'dart:convert';

import 'package:edar_app/data/model/invoice.dart';
import 'package:edar_app/data/network/network_service.dart';
import 'package:edar_app/routing/route_names.dart';

class InvoiceRepository {
  final NetworkService networkService;

  InvoiceRepository({required this.networkService});

  Future<List<Invoice>> fetchAll() async {
    final objRaw = await networkService.fetchAll(CategoriesRoute);
    return objRaw.map((e) => Invoice.fromJson(e)).toList();
  }

  Future<bool> addInvoice(Map<String, dynamic> invoiceObj) async {
    final isAdded = await networkService.addItem(invoiceObj, CategoriesRoute);

    return isAdded;
  }

  Future<bool> deleteInvoice(int invoiceId) async {
    final isDeleted =
        await networkService.deleteItem(invoiceId, CategoriesRoute);

    return isDeleted;
  }

  Future<bool> udpateInvoice(
      Map<String, dynamic> invoiceObj, int invoiceId) async {
    final isUpdated =
        await networkService.udpateItem(invoiceObj, invoiceId, CategoriesRoute);

    return isUpdated;
  }
}
