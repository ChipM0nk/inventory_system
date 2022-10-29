import 'package:edar_app/cubit/purchases/purchase_cubit.dart';
import 'package:edar_app/data/model/purchase/purchase.dart';
import 'package:edar_app/presentation/datasource/purchase_datasource.dart';
import 'package:edar_app/presentation/pages/purchases/purchase_dialog.dart';
import 'package:edar_app/presentation/widgets/custom_elevated_button.dart';
import 'package:edar_app/presentation/widgets/custom_paginated_datatable.dart';
import 'package:edar_app/presentation/widgets/fields/custom_date_picker.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PurchasePage extends StatefulWidget {
  const PurchasePage({Key? key}) : super(key: key);

  @override
  State<PurchasePage> createState() => _PurchasePageState();
}

class _PurchasePageState extends State<PurchasePage> {
  final searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    const dateFormat = 'dd-MMM-yy';
    var dateFrom = StreamBuilder<String>(
        stream: BlocProvider.of<PurchaseCubit>(context).dateFromStream,
        builder: (context, snapshot) {
          return Column(
            children: [
              CustomDatePicker(
                labelText: "Date From",
                width: 130,
                onChanged: (dateTime) {
                  BlocProvider.of<PurchaseCubit>(context)
                      .updateDateFrom(dateTime);
                },
                dateFormat: dateFormat,
                initialValue: snapshot.hasData ? snapshot.data : "",
              ),
            ],
          );
        });

    var dateTo = StreamBuilder<String>(
        stream: BlocProvider.of<PurchaseCubit>(context).dateToStream,
        builder: (context, snapshot) {
          return Column(
            children: [
              CustomDatePicker(
                labelText: "Date To",
                width: 130,
                onChanged: (dateTime) {
                  BlocProvider.of<PurchaseCubit>(context)
                      .updateDateTo(dateTime);
                },
                dateFormat: dateFormat,
                initialValue: snapshot.hasData ? snapshot.data : "",
              ),
            ],
          );
        });
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 400,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                dateFrom,
                dateTo,
                StreamBuilder<bool>(
                    stream: BlocProvider.of<PurchaseCubit>(context)
                        .filterButtonValid,
                    builder: (context, snapshot) {
                      return CustomElevatedButton(
                        onPressed: snapshot.hasData
                            ? () {
                                BlocProvider.of<PurchaseCubit>(context)
                                    .fetchPurchasesWithParam();
                              }
                            : null,
                        child: const Text("Filter"),
                      );
                    }),
                StreamBuilder<bool>(
                    stream: BlocProvider.of<PurchaseCubit>(context)
                        .filterButtonValid,
                    builder: (context, snapshot) {
                      return CustomElevatedButton(
                        onPressed: snapshot.hasData
                            ? () {
                                BlocProvider.of<PurchaseCubit>(context)
                                    .initSearch();
                                BlocProvider.of<PurchaseCubit>(context)
                                    .fetchPurchases();
                              }
                            : null,
                        child: const Text("Reset"),
                      );
                    }),
              ],
            ),
          ),
          SizedBox(
            width: 500,
            child: Row(
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
                            BlocProvider.of<PurchaseCubit>(context)
                                .searchPurchase(value),
                          }),
                ),
                const SizedBox(
                  width: 30,
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 1200,
              child: BlocBuilder<PurchaseCubit, PurchaseState>(
                builder: (context, state) {
                  print("Purchase state is $state");
                  if (state is! PurchaseLoaded) {
                    if (state is PurchaseInitial) {
                      BlocProvider.of<PurchaseCubit>(context).fetchPurchases();
                    }
                    return const Center(child: CircularProgressIndicator());
                  }

                  PurchaseData purchaseData = PurchaseData(
                      data: state.filteredData ?? state.purchases,
                      onItemClick: _openPurchaseDialog);
                  return CustomPaginatedDataTable(
                      header: const Text("Purchases"),
                      dataColumns: dataColumns(purchaseData),
                      dataRowHeight: 40,
                      rowsPerPage: 10,
                      sortAscending: state.sortAscending,
                      sortIndex: state.sortIndex,
                      source: purchaseData);
                },
              ),
            ),
          ),
        ]);
  }

  List<DataColumn> dataColumns(PurchaseData data) => <DataColumn>[
        DataColumn(
          label: const Text(
            'Purchase No',
            style: TextStyle(
                fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
          ),
          onSort: (colIdx, asc) {
            BlocProvider.of<PurchaseCubit>(context)
                .sortPurchase((purchase) => purchase.purchaseNo, colIdx, asc);
          },
        ),
        DataColumn(
          label: const Text(
            'Batch Code',
            style: TextStyle(
                fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
          ),
          onSort: (colIdx, asc) {
            BlocProvider.of<PurchaseCubit>(context)
                .sortPurchase((purchase) => purchase.batchCode, colIdx, asc);
          },
        ),
        const DataColumn(
            label: Text(
          'Supplier',
          style: TextStyle(
              fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
        )),
        DataColumn(
          label: const Text(
            'Purchase Date',
            style: TextStyle(
                fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
          ),
          onSort: (colIdx, asc) {
            BlocProvider.of<PurchaseCubit>(context)
                .sortPurchase((purchase) => purchase.purchaseDate, colIdx, asc);
          },
        ),
        const DataColumn(
          label: Text(
            'Total Amount',
            style: TextStyle(
                fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
          ),
        ),
        const DataColumn(
          label: Text(
            'Sales Person',
            style: TextStyle(
                fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
          ),
        ),
      ];

  void _openPurchaseDialog(Purchase purchase) {
    searchController.clear();
    showDialog(
        context: context,
        builder: (_) {
          return BlocProvider.value(
            value: context.read<PurchaseCubit>(),
            child: PurchaseDialog(purchase: purchase),
          );
        });
  }
}
