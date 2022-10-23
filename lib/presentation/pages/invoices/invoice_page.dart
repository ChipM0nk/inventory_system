import 'package:edar_app/cubit/invoice/invoice_cubit.dart';
import 'package:edar_app/data/model/invoice/invoice.dart';
import 'package:edar_app/presentation/datasource/invoice_datasource.dart';
import 'package:edar_app/presentation/pages/invoices/invoice_dialog.dart';
import 'package:edar_app/presentation/widgets/custom_paginated_datatable.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InvoicePage extends StatefulWidget {
  const InvoicePage({Key? key}) : super(key: key);

  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  final searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 1500,
        height: 1000,
        child: BlocBuilder<InvoiceCubit, InvoiceState>(
          builder: (context, state) {
            print("Invoice state is $state");
            if (state is! InvoiceLoaded) {
              if (state is InvoiceInitial) {
                BlocProvider.of<InvoiceCubit>(context).fetchInvoices();
              }
              return const Center(child: CircularProgressIndicator());
            }

            InvoiceData invoiceData = InvoiceData(
                data: state.filteredData ?? state.invoices,
                onItemClick: _openInvoiceDialog);
            return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                                    BlocProvider.of<InvoiceCubit>(context)
                                        .searchInvoice(value),
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
                      child: CustomPaginatedDataTable(
                          header: const Text("Invoice"),
                          dataColumns: dataColumns(invoiceData),
                          rowsPerPage: 10,
                          sortAscending: state.sortAscending,
                          sortIndex: state.sortIndex,
                          source: invoiceData),
                    ),
                  ),
                ]);
          },
        ));
  }

  List<DataColumn> dataColumns(InvoiceData data) => <DataColumn>[
        DataColumn(
          label: const Text(
            'Invoice No',
            style: TextStyle(
                fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
          ),
          onSort: (colIdx, asc) {
            BlocProvider.of<InvoiceCubit>(context)
                .sortInvoice((invoice) => invoice.invoiceNo, colIdx, asc);
          },
        ),
        DataColumn(
          label: const Text(
            'Customer Name',
            style: TextStyle(
                fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
          ),
          onSort: (colIdx, asc) {
            BlocProvider.of<InvoiceCubit>(context)
                .sortInvoice((invoice) => invoice.customerName, colIdx, asc);
          },
        ),
        const DataColumn(
            label: Text(
          'Contact No',
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
            BlocProvider.of<InvoiceCubit>(context)
                .sortInvoice((invoice) => invoice.purchaseDate, colIdx, asc);
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

  void _openInvoiceDialog(Invoice invoice) {
    searchController.clear();
    showDialog(
        context: context,
        builder: (_) {
          return BlocProvider.value(
            value: context.read<InvoiceCubit>(),
            child: InvoiceDialog(invoice: invoice),
          );
        });
  }
}
