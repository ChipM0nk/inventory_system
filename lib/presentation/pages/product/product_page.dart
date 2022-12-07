import 'package:edar_app/cubit/categories/categories_cubit.dart';
import 'package:edar_app/cubit/products/products_cubit.dart';
import 'package:edar_app/cubit/products/save_product_cubit.dart';
import 'package:edar_app/cubit/suppliers/suppliers_cubit.dart';
import 'package:edar_app/data/model/product.dart';
import 'package:edar_app/presentation/datasource/product_datasource.dart';
import 'package:edar_app/presentation/pages/product/product_dialog.dart';
import 'package:edar_app/presentation/widgets/custom_elevated_button.dart';
import 'package:edar_app/presentation/widgets/custom_paginated_datatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(height: 55),
      Row(
        children: [
          SizedBox(
            height: 20,
            width: 350,
            child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  hintText: 'Search',
                ),
                onChanged: (value) => {
                      BlocProvider.of<ProductsCubit>(context)
                          .searchProduct(value),
                    }),
          ),
          const SizedBox(
            width: 30,
          ),
          CustomElevatedButton(
            onPressed: () => showProductDialog(null),
            child: const Text("Add Product"),
          ),
        ],
      ),
      Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          width: 1200,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: BlocBuilder<ProductsCubit, ProductsState>(
              builder: (context, state) {
                if (state is! ProductsLoaded) {
                  BlocProvider.of<ProductsCubit>(context).fetchProducts();
                }

                if (state is ProductsLoaded) {
                  ProductData productData = ProductData(
                    data: state.filteredData ?? state.products,
                    onDeleteClick: _deleteProduct,
                    onItemClick: showProductDialog,
                  );
                  return CustomPaginatedDataTable(
                    header: const Text("Products"),
                    dataRowHeight: 40,
                    columnSpacing: 30,
                    dataColumns: dataColumns(productData),
                    rowsPerPage: 10,
                    sortAscending: state.sortAscending,
                    sortIndex: state.sortIndex,
                    source: productData,
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ),
      ),
    ]);
  }

  List<DataColumn> dataColumns(ProductData data) => <DataColumn>[
        DataColumn(
          label: const Text(
            'Code',
            style: TextStyle(
                fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
          ),
          onSort: (colIdx, asc) {
            BlocProvider.of<ProductsCubit>(context)
                .sortProducts((product) => product.productCode, colIdx, asc);
          },
        ),
        DataColumn(
          label: const Text(
            'Name',
            style: TextStyle(
                fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
          ),
          onSort: (colIdx, asc) {
            BlocProvider.of<ProductsCubit>(context)
                .sortProducts((product) => product.productName, colIdx, asc);
          },
        ),
        DataColumn(
          label: const Text(
            'Category',
            style: TextStyle(
                fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
          ),
          onSort: (colIdx, asc) {
            BlocProvider.of<ProductsCubit>(context).sortProducts(
                (product) => product.category.categoryName, colIdx, asc);
          },
        ),
        const DataColumn(
          label: Text(
            'Price',
            style: TextStyle(
                fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
          ),
        ),
        const DataColumn(
          label: SizedBox(
            width: 40,
            child: Text(
              'QTY',
              style: TextStyle(
                  fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const DataColumn(
          label: Text(
            'Unit',
            style: TextStyle(
                fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
          ),
        ),
        DataColumn(
          label: const Text(
            'Supplier',
            style: TextStyle(
                fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
          ),
          onSort: (colIdx, asc) {
            BlocProvider.of<ProductsCubit>(context).sortProducts(
                (product) => product.supplier.supplierName, colIdx, asc);
          },
        ),
        const DataColumn(
          label: Text(''),
        ),
      ];

  void _deleteProduct(int productId) {
    searchController.clear();
    showDialog(
        context: context,
        builder: (_) {
          return BlocProvider.value(
            value: context.read<ProductsCubit>(),
            child: AlertDialog(
              title: const Text("Delete"),
              content: BlocListener<ProductsCubit, ProductsState>(
                listener: (context, state) {
                  if (state is ProductDeleted) {
                    Navigator.of(context, rootNavigator: true).pop();
                  }
                },
                child: const Text("Are you sure you want to delete this item?"),
              ),
              actions: [
                ElevatedButton(
                    child: const Text("Yes"),
                    onPressed: () {
                      BlocProvider.of<ProductsCubit>(context)
                          .deleteProduct(productId);
                    }),
                ElevatedButton(
                    child: const Text("No"),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    }),
              ],
            ),
          );
        });
  }

  void showProductDialog(Product? product) {
    searchController.clear();
    showDialog(
        context: context,
        builder: (_) {
          return MultiBlocProvider(providers: [
            BlocProvider.value(value: context.read<ProductsCubit>()),
            BlocProvider.value(value: context.read<SaveProductCubit>()),
            BlocProvider.value(value: context.read<CategoriesCubit>()),
            BlocProvider.value(value: context.read<SuppliersCubit>()),
          ], child: ProductDialog(product: product));
        });
  }
}
