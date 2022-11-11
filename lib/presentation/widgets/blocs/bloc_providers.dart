import 'package:edar_app/cubit/categories/add_categories_cubit.dart';
import 'package:edar_app/cubit/categories/edit_categories_cubit.dart';
import 'package:edar_app/cubit/invoice/invoice_cubit.dart';
import 'package:edar_app/cubit/products/products_cubit.dart';
import 'package:edar_app/cubit/purchases/purchase_cubit.dart';
import 'package:edar_app/cubit/suppliers/suppliers_cubit.dart';
import 'package:edar_app/data/repository/invoice_repository.dart';
import 'package:edar_app/data/repository/product_repository.dart';
import 'package:edar_app/data/repository/purchase_repository.dart';
import 'package:edar_app/data/repository/supplier_repository.dart';
import 'package:edar_app/routing/route_names.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubit/categories/categories_cubit.dart';
import '../../../data/network/network_service.dart';
import '../../../data/repository/category_repository.dart';

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
    //TODO Change later
    InvoiceRepository invoiceRepository =
        InvoiceRepository(networkService: NetworkService());
    InvoiceCubit invoiceCubit =
        InvoiceCubit(invoiceRepository: invoiceRepository);
    ProductRepository productRepository =
        ProductRepository(networkService: NetworkService());
    ProductsCubit productCubit =
        ProductsCubit(productRepository: productRepository);
    return [
      BlocProvider<InvoiceCubit>(create: (context) => invoiceCubit),
      BlocProvider<ProductsCubit>(create: (context) => productCubit),
    ];
    // return MultiBlocProvider(providers: providers, child: child) BlocProvider<CategoriesCubit>(create: (context) => categoriesCubit);
  }

  static List<BlocProvider> _getPurchaseBlocProvider() {
    //TODO Change later
    PurchaseRepository purchaseRepository =
        PurchaseRepository(networkService: NetworkService());
    PurchaseCubit purchaseCubit =
        PurchaseCubit(purchaseRepository: purchaseRepository);
    ProductRepository productRepository =
        ProductRepository(networkService: NetworkService());
    ProductsCubit productCubit =
        ProductsCubit(productRepository: productRepository);
    SupplierRepository supplierRepository =
        SupplierRepository(networkService: NetworkService());
    SuppliersCubit suppliersCubit =
        SuppliersCubit(supplierRepository: supplierRepository);
    return [
      BlocProvider<PurchaseCubit>(create: (context) => purchaseCubit),
      BlocProvider<ProductsCubit>(create: (context) => productCubit),
      BlocProvider<SuppliersCubit>(create: (context) => suppliersCubit),
    ];
    // return MultiBlocProvider(providers: providers, child: child) BlocProvider<CategoriesCubit>(create: (context) => categoriesCubit);
  }

  static List<BlocProvider> _getCategoryBlocProvider() {
    // CategoryRepository categoryRepository =
    //     CategoryRepository(networkService: NetworkService());
    // CategoriesCubit categoriesCubit =
    //     CategoriesCubit(categoryRepository: categoryRepository);

    return [
      BlocProvider<CategoriesCubit>(create: (context) => CategoriesCubit()),
      BlocProvider<SaveCategoriesCubit>(
          create: (context) => SaveCategoriesCubit()),
      BlocProvider<EditCategoriesCubit>(
          create: (context) => EditCategoriesCubit())
    ];
  }

  static List<BlocProvider> _getSupplierBlocProvider() {
    SupplierRepository supplierRepository =
        SupplierRepository(networkService: NetworkService());
    SuppliersCubit suppliersCubit =
        SuppliersCubit(supplierRepository: supplierRepository);

    return [BlocProvider<SuppliersCubit>(create: (context) => suppliersCubit)];
  }

  static List<BlocProvider> _getProductBlocProvider() {
    ProductRepository productRepository =
        ProductRepository(networkService: NetworkService());
    ProductsCubit productCubit =
        ProductsCubit(productRepository: productRepository);

    CategoryRepository categoryRepository =
        CategoryRepository(networkService: NetworkService());
    // CategoriesCubit categoriesCubit =
    //     CategoriesCubit(categoryRepository: categoryRepository);
    CategoriesCubit categoriesCubit = CategoriesCubit();

    SupplierRepository supplierRepository =
        SupplierRepository(networkService: NetworkService());
    SuppliersCubit suppliersCubit =
        SuppliersCubit(supplierRepository: supplierRepository);
    return [
      BlocProvider<ProductsCubit>(create: (context) => productCubit),
      BlocProvider<CategoriesCubit>(create: (context) => CategoriesCubit()),
      BlocProvider<SuppliersCubit>(create: (context) => suppliersCubit)
    ];
  }
}
