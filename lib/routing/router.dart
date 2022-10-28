import 'package:edar_app/presentation/pages/category/category_page.dart';
import 'package:edar_app/presentation/pages/invoices/invoice_page.dart';
import 'package:edar_app/presentation/pages/product/product_page.dart';
import 'package:edar_app/presentation/pages/purchases/purchase_page.dart';
import 'package:edar_app/presentation/pages/purchases/purchaseform/purchase_form.dart';
import 'package:edar_app/presentation/pages/invoices/invoiceform/invoice_form.dart';
import 'package:edar_app/presentation/pages/supplier/supplier_page.dart';
import 'package:edar_app/presentation/widgets/content_card.dart';
import 'package:edar_app/routing/route_names.dart';
import 'package:flutter/material.dart';

//TODO: Can get the page from MenuList
Route<dynamic> generateRoute(RouteSettings settings) {
  print('Generate route: ${settings.name}');
  // Widget? page =
  //     MenuItemList.firstWhere((menu) => menu.route == settings.name).page;
  // if (page != null) {}
  switch (settings.name) {
    case InvoiceFormRoute:
      return _getPageRoute(const InvoiceForm(), settings);
    case InvoicesRoute:
      return _getPageRoute(const InvoicePage(), settings);
    case PurchaseFormRoute:
      return _getPageRoute(const PurchaseForm(), settings);
    case PurchasesRoute:
      return _getPageRoute(const PurchasePage(), settings);
    case CategoriesRoute:
      return _getPageRoute(const CategoryPage(), settings);
    case SuppliersRoute:
      return _getPageRoute(const SupplierPage(), settings);
    case ProductsRoute:
      return _getPageRoute(const ProductPage(), settings);
    default:
      return _getPageRoute(const InvoiceForm(), settings); //change to home
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
