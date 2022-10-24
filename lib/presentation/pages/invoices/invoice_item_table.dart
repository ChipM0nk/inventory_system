import 'package:edar_app/data/model/invoice/invoice_item.dart';
import 'package:edar_app/presentation/widgets/fields/numeric_text.dart';
import 'package:flutter/material.dart';

class InvoiceItemTable extends StatelessWidget {
  final List<InvoiceItem> invoiceItems;
  final Function(InvoiceItem)? deleteInvoiceItem;
  const InvoiceItemTable(
      {required this.invoiceItems, this.deleteInvoiceItem, super.key});

  @override
  Widget build(BuildContext context) {
    var invoiceItemList = invoiceItems
        .map(
          (iv) => DataRow(
            cells: [
              DataCell(
                  SizedBox(width: 180, child: Text(iv.product.productName))),
              DataCell(SizedBox(
                width: 260,
                child: Tooltip(
                    message: iv.product.productDescription,
                    child: Text(
                      iv.product.productDescription,
                      overflow: TextOverflow.ellipsis,
                    )),
              )),
              DataCell(SizedBox(
                  width: 100, child: NumericText(text: iv.price.toString()))),
              DataCell(
                  SizedBox(width: 60, child: Text(iv.quantity.toString()))),
              DataCell(SizedBox(width: 50, child: Text(iv.product.unit))),
              DataCell(SizedBox(
                  width: 100,
                  child: NumericText(text: iv.totalAmount.toString()))),
              if (deleteInvoiceItem != null)
                DataCell(SizedBox(
                  width: 10,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.delete,
                      size: 15,
                      color: Colors.red,
                    ),
                    onPressed: () => deleteInvoiceItem!(iv),
                  ),
                ))
            ],
          ),
        )
        .toList();

    const emptyDataCells = [
      DataCell(SizedBox(
        width: 180,
      )),
      DataCell(SizedBox(
        width: 260,
      )),
      DataCell(SizedBox(
        width: 100,
      )),
      DataCell(SizedBox(
        width: 60,
      )),
      DataCell(SizedBox(
        width: 50,
      )),
      DataCell(SizedBox(
        width: 100,
      )),
    ];

    const emptyListNonEditable = [
      DataRow(cells: [
        ...emptyDataCells,
      ])
    ];

    var emptyListEditable = [
      const DataRow(cells: [
        ...emptyDataCells,
        DataCell(
          SizedBox(
            width: 10,
          ),
        ),
      ])
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
        headingRowHeight: 30,
        columnSpacing: 30,
        headingRowColor: MaterialStateColor.resolveWith(
          (states) {
            return Colors.green.shade200;
          },
        ),
        dataRowHeight: 20,
        border: TableBorder.all(
            width: 1.0,
            style: BorderStyle.solid,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        columns: <DataColumn>[
          const DataColumn(
            label: SizedBox(
              width: 180,
              child: Text(
                'Product Name',
                style: TextStyle(
                    fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const DataColumn(
            label: SizedBox(
              width: 260,
              child: Text(
                'Product Description',
                style: TextStyle(
                    fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const DataColumn(
            label: SizedBox(
              width: 100,
              child: Text(
                'Price',
                style: TextStyle(
                    fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const DataColumn(
            label: SizedBox(
              width: 60,
              child: Text(
                'Quantity',
                style: TextStyle(
                    fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const DataColumn(
            label: SizedBox(
              width: 50,
              child: Text(
                'Unit',
                style: TextStyle(
                    fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const DataColumn(
            label: SizedBox(
              width: 100,
              child: Text(
                'Total',
                style: TextStyle(
                    fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          if (deleteInvoiceItem != null)
            const DataColumn(
              label: SizedBox(
                width: 10,
                child: Text(
                  '',
                  style: TextStyle(
                      fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
        rows: invoiceItemList.isEmpty
            ? deleteInvoiceItem == null
                ? emptyListNonEditable
                : emptyListEditable
            : invoiceItemList,
      ),
    );
  }
}
