import 'package:edar_app/cubit/categories/categories_cubit.dart';
import 'package:edar_app/cubit/products/products_cubit.dart';
import 'package:edar_app/cubit/suppliers/suppliers_cubit.dart';
import 'package:edar_app/data/model/product.dart';
import 'package:edar_app/presentation/datasource/product_datasource.dart';
import 'package:edar_app/presentation/pages/product/product_dialog.dart';
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
    return SizedBox(
      width: 1800,
      height: 1300,
      child: BlocBuilder<ProductsCubit, ProductsState>(
        builder: (context, state) {
          if (state is! ProductsLoaded) {
            if (state is ProductsInitial) {
              BlocProvider.of<ProductsCubit>(context).fetchProducts();
            }
            return const Center(child: CircularProgressIndicator());
          }

          ProductData productData = ProductData(
              data: state.filteredData ?? state.products,
              onDeleteClick: _deleteProduct,
              onItemClick: _openUpdateProductDialog);
          return Column(children: [
            Row(
              children: [
                SizedBox(
                  height: 20,
                  width: 450,
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
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) {
                          searchController.clear();
                          return BlocProvider.value(
                            value: context.read<ProductsCubit>(),
                            child: MultiBlocProvider(providers: [
                              BlocProvider.value(
                                  value: context.read<ProductsCubit>()),
                              BlocProvider.value(
                                  value: context.read<CategoriesCubit>()),
                              BlocProvider.value(
                                  value: context.read<SuppliersCubit>()),
                            ], child: ProductDialog()),
                          );
                        });
                  },
                  child: const Text("Add Product"),
                ),
              ],
            ),
            Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: 1200,
                child: CustomPaginatedDataTable(
                    header: const Text("Products"),
                    dataColumns: dataColumns(productData),
                    rowsPerPage: 10,
                    sortAscending: state.sortAscending,
                    sortIndex: state.sortIndex,
                    source: productData),
              ),
            ),
          ]);
        },
      ),
    );
  }

  List<DataColumn> dataColumns(ProductData data) => <DataColumn>[
        DataColumn(
          label: const Text(
            'Name',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
          onSort: (colIdx, asc) {
            BlocProvider.of<ProductsCubit>(context)
                .sortProducts((product) => product.productName, colIdx, asc);
          },
        ),
        DataColumn(
          label: const Text(
            'Description',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
          onSort: (colIdx, asc) {
            BlocProvider.of<ProductsCubit>(context).sortProducts(
                (product) => product.productDescription, colIdx, asc);
          },
        ),
        DataColumn(
          label: const Text(
            'Price',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
          onSort: (colIdx, asc) {
            BlocProvider.of<ProductsCubit>(context)
                .sortProducts((product) => product.productPrice, colIdx, asc);
          },
        ),
        DataColumn(
          label: const Text(
            'Quantity',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
          onSort: (colIdx, asc) {
            BlocProvider.of<ProductsCubit>(context).sortProducts(
                (product) => product.productQuantity, colIdx, asc);
          },
        ),
        DataColumn(
          label: const Text(
            'Unit',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
          onSort: (colIdx, asc) {
            BlocProvider.of<ProductsCubit>(context)
                .sortProducts((product) => product.productUnit, colIdx, asc);
          },
        ),
        const DataColumn(
          label: Text(
            'Category',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        const DataColumn(
          label: Text(
            'Supplier',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        const DataColumn(
          label: Text(''),
        ),
      ];

  void _deleteProduct(int productId) {
    print('deleting product : ${productId}');

    searchController.clear();
    showDialog(
        context: context,
        builder: (_) {
          return BlocProvider.value(
            value: context.read<ProductsCubit>(),
            child: AlertDialog(
              title: Text("Delete"),
              content: BlocListener<ProductsCubit, ProductsState>(
                listener: (context, state) {
                  if (state is ProductDeleted) {
                    Navigator.of(context, rootNavigator: true).pop();
                  }
                },
                child: Text("Are you sure you want to delete this item?"),
              ),
              actions: [
                ElevatedButton(
                    child: Text("Yes"),
                    onPressed: () {
                      BlocProvider.of<ProductsCubit>(context)
                          .deleteProduct(productId);
                    }),
                ElevatedButton(
                    child: Text("No"),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    }),
              ],
            ),
          );
        });
  }

  void _openUpdateProductDialog(Product product) {
    print('updating product : ${product.productId}');

    searchController.clear();
    showDialog(
        context: context,
        builder: (_) {
          return MultiBlocProvider(providers: [
            BlocProvider.value(value: context.read<ProductsCubit>()),
            BlocProvider.value(value: context.read<CategoriesCubit>()),
            BlocProvider.value(value: context.read<SuppliersCubit>()),
          ], child: ProductDialog(product: product));
        });
  }
}
