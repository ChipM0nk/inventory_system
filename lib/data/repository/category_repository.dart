import 'package:edar_app/constants/services.dart';
import 'package:edar_app/data/model/category.dart';
import 'package:edar_app/data/network/network_service.dart';

class CategoryRepository {
  final NetworkService networkService = NetworkService();

  CategoryRepository();

  Future<List<Category>> fetchAll() async {
    final objRaw = await networkService.fetchAll(CategoriesService);
    return objRaw.map((e) => Category.fromJson(e)).toList();
  }

  Future<bool> addCategory(Map<String, dynamic> categoryObj) async {
    final isAdded =
        await networkService.addItem(categoryObj, CategoriesService);

    return isAdded;
  }

  Future<bool> deleteCategory(int categoryId) async {
    final isDeleted =
        await networkService.deleteItem(categoryId, CategoriesService);

    return isDeleted;
  }

  Future<bool> udpateCategory(
      Map<String, dynamic> categoryObj, int categoryId) async {
    final isUpdated = await networkService.udpateItem(
        categoryObj, categoryId, CategoriesService);

    return isUpdated;
  }
}
