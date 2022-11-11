import 'package:edar_app/constants/services.dart';
import 'package:edar_app/data/model/product.dart';
import 'package:edar_app/data/network/network_service.dart';

class ProductRepository {
  final NetworkService networkService = NetworkService();

  ProductRepository();

  Future<List<Product>> fetchAll() async {
    final objRaw = await networkService.fetchAll(ProductsService);
    return objRaw.map((e) => Product.fromJson(e)).toList();
  }

  Future<bool> addProduct(Map<String, dynamic> productObj) async {
    final isAdded = await networkService.addItem(productObj, ProductsService);

    return isAdded;
  }

  Future<bool> deleteProduct(int productId) async {
    final isDeleted =
        await networkService.deleteItem(productId, ProductsService);

    return isDeleted;
  }

  Future<bool> udpateProduct(
      Map<String, dynamic> productObj, int productId) async {
    final isUpdated =
        await networkService.udpateItem(productObj, productId, ProductsService);

    return isUpdated;
  }
}
