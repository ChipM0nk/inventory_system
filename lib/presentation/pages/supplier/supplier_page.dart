import 'package:edar_app/cubit/suppliers/suppliers_cubit.dart';
import 'package:edar_app/data/model/supplier.dart';
import 'package:edar_app/presentation/datasource/supplier_datasource.dart';
import 'package:edar_app/presentation/pages/supplier/supplier_dialog.dart';
import 'package:edar_app/presentation/widgets/custom_paginated_datatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SupplierPage extends StatefulWidget {
  const SupplierPage({Key? key}) : super(key: key);

  @override
  State<SupplierPage> createState() => _SupplierPageState();
}

class _SupplierPageState extends State<SupplierPage> {
  final searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1800,
      height: 1300,
      child: BlocBuilder<SuppliersCubit, SuppliersState>(
        builder: (context, state) {
          if (state is! SuppliersLoaded) {
            if (state is SuppliersInitial) {
              BlocProvider.of<SuppliersCubit>(context).fetchSuppliers();
            }
            return const Center(child: CircularProgressIndicator());
          }

          SupplierData supplierData = SupplierData(
              data: state.filteredData ?? state.suppliers,
              onDeleteClick: _deleteSupplier,
              onItemClick: _openUpdateSupplierDialog);
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
                            BlocProvider.of<SuppliersCubit>(context)
                                .searchSupplier(value),
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
                            value: context.read<SuppliersCubit>(),
                            child: SupplierDialog(),
                          );
                        });
                  },
                  child: const Text("Add Supplier"),
                ),
              ],
            ),
            Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: 800,
                child: CustomPaginatedDataTable(
                  header: const Text("Suppliers"),
                  dataColumns: dataColumns(supplierData),
                  rowsPerPage: 10,
                  sortAscending: state.sortAscending,
                  sortIndex: state.sortIndex,
                  source: supplierData,
                ),
              ),
            ),
          ]);
        },
      ),
    );
  }

  List<DataColumn> dataColumns(SupplierData data) => <DataColumn>[
        DataColumn(
          label: const Text(
            'Name',
            style: TextStyle(
                fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
          ),
          onSort: (colIdx, asc) {
            BlocProvider.of<SuppliersCubit>(context).sortSuppliers(
                (supplier) => supplier.supplierName, colIdx, asc);
          },
        ),
        const DataColumn(
            label: Text(
          'Contact Number',
          style: TextStyle(
              fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
        )),
        const DataColumn(
          label: Text(
            'Email Address',
            style: TextStyle(
                fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
          ),
        ),
        const DataColumn(
            label: Text(
          'Address',
          style: TextStyle(
              fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
        )),
        const DataColumn(
          label: Text(''),
        ),
      ];

  void _deleteSupplier(int supplierId) {
    print('deleting supplier : ${supplierId}');

    searchController.clear();
    showDialog(
        context: context,
        builder: (_) {
          return BlocProvider.value(
            value: context.read<SuppliersCubit>(),
            child: AlertDialog(
              title: Text("Delete"),
              content: BlocListener<SuppliersCubit, SuppliersState>(
                listener: (context, state) {
                  if (state is SupplierDeleted) {
                    Navigator.of(context, rootNavigator: true).pop();
                  }
                },
                child: Text("Are you sure you want to delete this item?"),
              ),
              actions: [
                ElevatedButton(
                    child: Text("Yes"),
                    onPressed: () {
                      BlocProvider.of<SuppliersCubit>(context)
                          .deleteSupplier(supplierId);
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

  void _openUpdateSupplierDialog(Supplier supplier) {
    print('updating supplier : ${supplier.supplierId}');
    searchController.clear();
    showDialog(
        context: context,
        builder: (_) {
          return BlocProvider.value(
            value: context.read<SuppliersCubit>(),
            child: SupplierDialog(supplier: supplier),
          );
        });
  }
}
