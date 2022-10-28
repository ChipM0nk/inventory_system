import 'package:edar_app/presentation/widgets/navbar/custom_menu_Item.dart';
import 'package:edar_app/routing/route_names.dart';
import 'package:flutter/material.dart';
import 'package:side_navigation/side_navigation.dart';

// ignore: non_constant_identifier_names
var MenuItemList = [
  CustomMenuItem(
      sideNavigationBarItem: const SideNavigationBarItem(
        icon: Icons.point_of_sale,
        label: 'Invoice Form',
      ),
      // page: const SalesForm(),
      route: InvoiceFormRoute),
  CustomMenuItem(
      sideNavigationBarItem: const SideNavigationBarItem(
        icon: Icons.shopping_basket,
        label: 'Purchase Form',
      ),
      // page: const SupplierPage(),
      route: PurchaseFormRoute),
  CustomMenuItem(
      sideNavigationBarItem: const SideNavigationBarItem(
        icon: Icons.shop_2,
        label: 'Invoices',
      ),
      // page: const SalesForm(),
      route: InvoicesRoute),
  CustomMenuItem(
      sideNavigationBarItem: const SideNavigationBarItem(
        icon: Icons.shopping_cart_checkout,
        label: 'Purchases',
      ),
      // page: const SupplierPage(),
      route: PurchasesRoute),
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
        icon: Icons.shower,
        label: 'Product',
      ),
      // page: const SupplierPage(),
      route: ProductsRoute),
];
