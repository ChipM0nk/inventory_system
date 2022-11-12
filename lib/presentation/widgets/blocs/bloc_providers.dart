import 'package:edar_app/cubit/categories/categories_cubit.dart';
import 'package:edar_app/cubit/categories/save_categories_cubit.dart';
import 'package:edar_app/cubit/invoice/invoice_cubit.dart';
import 'package:edar_app/cubit/invoice/save_invoice_cubit.dart';
import 'package:edar_app/cubit/products/products_cubit.dart';
import 'package:edar_app/cubit/products/save_product_cubit.dart';
import 'package:edar_app/cubit/purchases/purchase_cubit.dart';
import 'package:edar_app/cubit/purchases/save_purchase_cubit.dart';
import 'package:edar_app/cubit/suppliers/save_suppliers_cubit.dart';
import 'package:edar_app/cubit/suppliers/suppliers_cubit.dart';
import 'package:edar_app/routing/route_names.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocProviders {
  static getBlockProvider(String route) {
    switch (route) {
      case InvoiceFormRoute:
      case InvoicesRoute:
        print("Sales form/page loaded");
        return _getInvoiceFormBlockProvider();
      case PurchaseFormRoute:
      case PurchasesRoute:
        print("Purchase form/page loaded");
        return _getPurchaseBlocProvider();
      case CategoriesRoute:
        print("Category page loaded");
        return _getCategoryBlocProvider();
      case SuppliersRoute:
        print("Supplier page loaded");
        return _getSupplierBlocProvider();
      case ProductsRoute:
        print("Supplier page loaded");
        return _getProductBlocProvider();

      default:
        return _getCategoryBlocProvider();
    }
  }

  static List<BlocProvider> _getInvoiceFormBlockProvider() {
    return [
      BlocProvider<InvoiceCubit>(create: (context) => InvoiceCubit()),
      BlocProvider<SaveInvoiceCubit>(create: (context) => SaveInvoiceCubit()),
      BlocProvider<ProductsCubit>(create: (context) => ProductsCubit()),
    ];
  }

  static List<BlocProvider> _getPurchaseBlocProvider() {
    return [
      BlocProvider<PurchaseCubit>(create: (context) => PurchaseCubit()),
      BlocProvider<SavePurchaseCubit>(create: (context) => SavePurchaseCubit()),
      BlocProvider<ProductsCubit>(create: (context) => ProductsCubit()),
      BlocProvider<SuppliersCubit>(create: (context) => SuppliersCubit()),
    ];
  }

  static List<BlocProvider> _getCategoryBlocProvider() {
    return [
      BlocProvider<CategoriesCubit>(create: (context) => CategoriesCubit()),
      BlocProvider<SaveCategoriesCubit>(
          create: (context) => SaveCategoriesCubit()),
    ];
  }

  static List<BlocProvider> _getSupplierBlocProvider() {
    return [
      BlocProvider<SuppliersCubit>(create: (context) => SuppliersCubit()),
      BlocProvider<SaveSuppliersCubit>(
          create: (context) => SaveSuppliersCubit())
    ];
  }

  static List<BlocProvider> _getProductBlocProvider() {
    return [
      BlocProvider<ProductsCubit>(create: (context) => ProductsCubit()),
      BlocProvider<SaveProductCubit>(create: (context) => SaveProductCubit()),
      BlocProvider<CategoriesCubit>(create: (context) => CategoriesCubit()),
      BlocProvider<SuppliersCubit>(create: (context) => SuppliersCubit())
    ];
  }
}
