import 'package:edar_app/data/model/invoice/invoice.dart';
import 'package:edar_app/presentation/pages/invoices/datagrid/invoice_item_grid_datasource.dart';
import 'package:edar_app/presentation/utils/util.dart';
import 'package:edar_app/presentation/widgets/custom_sfdatagrid.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class InvoiceItemDataGrid extends StatelessWidget {
  final Invoice invoice;
  const InvoiceItemDataGrid({required this.invoice, super.key});

  @override
  Widget build(BuildContext context) {
    InvoiceItemGriDataSource invoiceItemGriDataSource =
        InvoiceItemGriDataSource(invoiceItems: invoice.invoiceItems);

    var footer = Container(
        color: Colors.grey[400],
        child: Center(
            child: RichText(
                text: TextSpan(
                    text: 'TOTAL : ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    children: [
              TextSpan(
                  text:
                      'PHP ${Util.convertToCurrency(invoice.totalAmount).toString()}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.red)),
            ]))));

    var stackHeaderRows = <StackedHeaderRow>[
      StackedHeaderRow(cells: [
        StackedHeaderCell(
            columnNames: ['prodname', 'proddesc', 'price', 'qty', 'total'],
            child: Container(
              color: Colors.blue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [Text("Test"), Text("Test 2")],
              ),
            ))
      ]),
    ];
    return CustomSfDataGrid(
      stackedHeaderRows: stackHeaderRows,
      footer: footer,
      source: invoiceItemGriDataSource,
      columns: <GridColumn>[
        GridColumn(
            columnName: 'prodname',
            width: 250,
            label: Container(
                padding: const EdgeInsets.all(5.0),
                height: 20,
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Product Name',
                ))),
        GridColumn(
            columnName: 'proddesc',
            width: 350,
            label: Container(
                padding: const EdgeInsets.all(5.0),
                height: 20,
                alignment: Alignment.centerLeft,
                child: const Text('Product Desciption'))),
        GridColumn(
            columnName: 'price',
            width: 133,
            label: Container(
                padding: const EdgeInsets.all(5.0),
                height: 20,
                alignment: Alignment.centerRight,
                child: const Text('Price'))),
        GridColumn(
            columnName: 'qty',
            width: 133,
            label: Container(
                padding: const EdgeInsets.all(5.0),
                height: 20,
                alignment: Alignment.centerRight,
                child: const Text('Quantity'))),
        GridColumn(
            columnName: 'total',
            width: 133,
            label: Container(
                padding: const EdgeInsets.all(5.0),
                height: 20,
                alignment: Alignment.centerRight,
                child: const Text('Total'))),
      ],
    );
  }
}
