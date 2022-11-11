import 'package:edar_app/constants/services.dart';
import 'package:edar_app/data/model/invoice/invoice.dart';
import 'package:edar_app/data/network/network_service.dart';

class InvoiceRepository {
  final NetworkService networkService;

  InvoiceRepository({required this.networkService});

  Future<List<Invoice>> fetchWithParam(Map<String, dynamic> paramObj) async {
    final objRaw =
        await networkService.fetchWithParam(InvoicesService, paramObj);
    return objRaw.map((e) => Invoice.fromJson(e)).toList();
  }

  Future<List<Invoice>> fetchAll() async {
    final objRaw = await networkService.fetchAll(InvoicesService);
    return objRaw.map((e) => Invoice.fromJson(e)).toList();
  }

  Future<bool> addInvoice(Map<String, dynamic> invoiceObj) async {
    final isAdded = await networkService.addItem(invoiceObj, InvoicesService);

    return isAdded;
  }

  Future<bool> voidInvoice(int invoiceId) async {
    final isVoided = await networkService.voidItem(invoiceId, InvoicesService);

    return isVoided;
  }

  Future<bool> udpateInvoice(
      Map<String, dynamic> invoiceObj, int invoiceId) async {
    final isUpdated =
        await networkService.udpateItem(invoiceObj, invoiceId, InvoicesService);
    return isUpdated;
  }
}
