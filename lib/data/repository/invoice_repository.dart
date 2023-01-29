import 'dart:collection';

import 'package:edar_app/constants/services.dart';
import 'package:edar_app/data/model/invoice/invoice.dart';
import 'package:edar_app/data/network/network_service.dart';

class InvoiceRepository {
  final NetworkService networkService = NetworkService();

  InvoiceRepository();

  Future<List<Invoice>> fetchWithParam(Map<String, dynamic> paramObj) async {
    final objRaw =
        await networkService.fetchWithParam(InvoicesService, paramObj);
    return objRaw.map((e) => Invoice.fromJson(e)).toList();
  }

  Future<List<Invoice>> fetchAll() async {
    final objRaw = await networkService.fetchAll(InvoicesService);
    print(objRaw);
    return objRaw.map((e) => Invoice.fromJson(e)).toList();
  }

  Future<Map<String, dynamic>> addInvoice(
      Map<String, dynamic> invoiceObj) async {
    print(invoiceObj);
    dynamic invoiceRetObj =
        await networkService.addandReturnItem(invoiceObj, InvoicesService);

    return invoiceRetObj;
  }

  Future<bool> voidInvoice(int invoiceId) async {
    final isVoided = await networkService.voidItem(invoiceId, InvoicesService);

    return isVoided;
  }

  Future<bool> finalizeInvoice(int invoiceId) async {
    final isFinalized =
        await networkService.finalizeInvoice(invoiceId, InvoicesService);

    return isFinalized;
  }

  Future<bool> udpateInvoice(
      Map<String, dynamic> invoiceObj, int invoiceId) async {
    final isUpdated =
        await networkService.udpateItem(invoiceObj, invoiceId, InvoicesService);
    return isUpdated;
  }
}
