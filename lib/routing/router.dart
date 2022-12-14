import 'package:edar_app/presentation/pages/category/category_page.dart';
import 'package:edar_app/presentation/pages/product/product_page.dart';
import 'package:edar_app/presentation/pages/sales/sales_form.dart';
import 'package:edar_app/presentation/pages/supplier/supplier_page.dart';
import 'package:edar_app/presentation/widgets/content_card.dart';
import 'package:edar_app/presentation/widgets/navbar/custom_menu_list.dart';
import 'package:edar_app/routing/route_names.dart';
import 'package:flutter/material.dart';

//TODO: Can get the page from MenuList
Route<dynamic> generateRoute(RouteSettings settings) {
  print('Generate route: ${settings.name}');
  // Widget? page =
  //     MenuItemList.firstWhere((menu) => menu.route == settings.name).page;
  // if (page != null) {}
  switch (settings.name) {
    case SalesRoute:
      return _getPageRoute(SalesForm(), settings);
    case CategoriesRoute:
      return _getPageRoute(CategoryPage(), settings);
    case SuppliersRoute:
      return _getPageRoute(SupplierPage(), settings);
    case ProductsRoute:
      return _getPageRoute(ProductPage(), settings);
    default:
      return _getPageRoute(SalesForm(), settings);
  }
}

PageRoute _getPageRoute(Widget child, RouteSettings settings) {
  return _FadeRoute(child: child, settings: settings);
  // return MaterialPageRoute(
  //     builder: (context) => ContentCard(route: settings.name!, child: child));
}

class _FadeRoute extends PageRouteBuilder {
  final Widget child;
  final RouteSettings settings;
  _FadeRoute({required this.child, required this.settings})
      : super(
          settings: settings,
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              child,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: ContentCard(route: settings.name!, child: child),
          ),
        );
}
