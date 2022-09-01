import 'package:edar_app/presentation/widgets/navbar/custom_menu_Item.dart';
import 'package:edar_app/routing/route_names.dart';
import 'package:flutter/material.dart';
import 'package:side_navigation/side_navigation.dart';

// ignore: non_constant_identifier_names
var MenuItemList = [
  CustomMenuItem(
      sideNavigationBarItem: const SideNavigationBarItem(
        icon: Icons.point_of_sale,
        label: 'Sales Form',
      ),
      // page: const SalesForm(),
      route: SalesRoute),
  CustomMenuItem(
      sideNavigationBarItem: const SideNavigationBarItem(
        icon: Icons.category,
        label: 'Category',
      ),
      // page: const CategoryPage(),
      route: CategoriesRoute),
  CustomMenuItem(
      sideNavigationBarItem: const SideNavigationBarItem(
        icon: Icons.factory,
        label: 'Supplier',
      ),
      // page: const SupplierPage(),
      route: SuppliersRoute),
  CustomMenuItem(
      sideNavigationBarItem: const SideNavigationBarItem(
        icon: Icons.umbrella,
        label: 'Product',
      ),
      // page: const SupplierPage(),
      route: ProductsRoute),
];
