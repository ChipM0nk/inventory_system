import 'package:edar_app/constants/services.dart';
import 'package:edar_app/data/model/invoice/invoice.dart';
import 'package:edar_app/data/network/network_service.dart';

class InvoiceRepository {
  final NetworkService networkService;

  InvoiceRepository({required this.networkService});

  Future<List<Invoice>> fetchAll() async {
    final objRaw = await networkService.fetchAll(InvoicesService);
    return objRaw.map((e) => Invoice.fromJson(e)).toList();
  }

  Future<bool> addInvoice(Map<String, dynamic> invoiceObj) async {
    final isAdded = await networkService.addItem(invoiceObj, InvoicesService);

    return isAdded;
  }

  Future<bool> deleteInvoice(int invoiceId) async {
    final isDeleted =
        await networkService.deleteItem(invoiceId, InvoicesService);

    return isDeleted;
  }

  Future<bool> udpateInvoice(
      Map<String, dynamic> invoiceObj, int invoiceId) async {
    final isUpdated =
        await networkService.udpateItem(invoiceObj, invoiceId, InvoicesService);
    return isUpdated;
  }
}
