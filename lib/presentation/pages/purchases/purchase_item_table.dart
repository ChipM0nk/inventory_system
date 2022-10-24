import 'package:edar_app/data/model/purchase/purchase_item.dart';
import 'package:edar_app/presentation/widgets/fields/numeric_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class PurchaseItemTable extends StatelessWidget {
  final List<PurchaseItem> purchaseItems;
  final Function(PurchaseItem)? deletePurchaseItem;
  const PurchaseItemTable(
      {required this.purchaseItems, this.deletePurchaseItem, super.key});

  @override
  Widget build(BuildContext context) {
    var purchaseItemRows = purchaseItems
        .map(
          (iv) => DataRow(
            cells: [
              DataCell(SizedBox(
                width: 260,
                child: Tooltip(
                    message: iv.product.productDescription,
                    child: Text(
                      iv.product.productName,
                      overflow: TextOverflow.ellipsis,
                    )),
              )),
              DataCell(SizedBox(
                  width: 100,
                  child: NumericText(text: iv.itemAmount.toString()))),
              DataCell(
                  SizedBox(width: 100, child: Text(iv.quantity.toString()))),
              DataCell(SizedBox(
                  width: 100,
                  child: NumericText(text: iv.itemTotalAmount.toString()))),
              if (deletePurchaseItem != null)
                DataCell(SizedBox(
                  width: 10,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.delete,
                      size: 15,
                      color: Colors.red,
                    ),
                    onPressed: () => deletePurchaseItem!(iv),
                  ),
                )),
            ],
          ),
        )
        .toList();

    const dataCellList = [
      DataCell(SizedBox(
        width: 260,
      )),
      DataCell(SizedBox(
        width: 100,
      )),
      DataCell(SizedBox(
        width: 100,
      )),
      DataCell(SizedBox(
        width: 100,
      ))
    ];
    const emptyListEditable = [
      DataRow(cells: [
        ...dataCellList,
        DataCell(SizedBox(
          width: 10,
        )),
      ])
    ];
    const emptyListNonEditable = [
      DataRow(cells: [
        ...dataCellList,
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
        columns: const <DataColumn>[
          DataColumn(
            label: SizedBox(
              width: 180,
              child: Text(
                'Product',
                style: TextStyle(
                    fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          DataColumn(
            label: SizedBox(
              width: 260,
              child: Text(
                'Purchase Amount',
                style: TextStyle(
                    fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          DataColumn(
            label: SizedBox(
              width: 100,
              child: Text(
                'Quantity',
                style: TextStyle(
                    fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          DataColumn(
            label: SizedBox(
              width: 100,
              child: Text(
                'Total',
                style: TextStyle(
                    fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          DataColumn(
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
        rows: purchaseItemRows.isEmpty
            ? deletePurchaseItem == null
                ? emptyListNonEditable
                : emptyListEditable
            : purchaseItemRows,
      ),
    );
  }
}
