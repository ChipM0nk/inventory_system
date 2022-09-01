import 'package:edar_app/data/model/product.dart';
import 'package:edar_app/data/network/network_service.dart';
import 'package:edar_app/routing/route_names.dart';

class ProductRepository {
  final NetworkService networkService;

  ProductRepository({required this.networkService});

  Future<List<Product>> fetchAll() async {
    final objRaw = await networkService.fetchAll(ProductsRoute);
    return objRaw.map((e) => Product.fromJson(e)).toList();
  }

  Future<bool> addProduct(Map<String, dynamic> productObj) async {
    final isAdded = await networkService.addItem(productObj, ProductsRoute);

    return isAdded;
  }

  Future<bool> deleteProduct(int productId) async {
    final isDeleted = await networkService.deleteItem(productId, ProductsRoute);

    return isDeleted;
  }

  Future<bool> udpateProduct(
      Map<String, dynamic> productObj, int productId) async {
    final isUpdated =
        await networkService.udpateItem(productObj, productId, ProductsRoute);

    return isUpdated;
  }
}
