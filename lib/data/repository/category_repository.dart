import 'dart:convert';

import 'package:edar_app/data/model/category.dart';
import 'package:edar_app/data/network/network_service.dart';
import 'package:edar_app/routing/route_names.dart';

class CategoryRepository {
  final NetworkService networkService;

  CategoryRepository({required this.networkService});

  Future<List<Category>> fetchAll() async {
    final objRaw = await networkService.fetchAll(CategoriesRoute);
    return objRaw.map((e) => Category.fromJson(e)).toList();
  }

  Future<bool> addCategory(Map<String, dynamic> categoryObj) async {
    final isAdded = await networkService.addItem(categoryObj, CategoriesRoute);

    return isAdded;
  }

  Future<bool> deleteCategory(int categoryId) async {
    final isDeleted =
        await networkService.deleteItem(categoryId, CategoriesRoute);

    return isDeleted;
  }

  Future<bool> udpateCategory(
      Map<String, dynamic> categoryObj, int categoryId) async {
    final isUpdated = await networkService.udpateItem(
        categoryObj, categoryId, CategoriesRoute);

    return isUpdated;
  }
}
