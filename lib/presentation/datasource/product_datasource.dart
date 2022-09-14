import 'package:edar_app/data/model/product.dart';
import 'package:flutter/material.dart';

typedef OnRowSelect = void Function(int index);
typedef OnDeleteClick = void Function(int index);
typedef OnItemClick = void Function(Product product);

class ProductData extends DataTableSource {
  final List<Product> data;
  final OnDeleteClick onDeleteClick;
  final OnItemClick onItemClick;

  ProductData(
      {required this.data,
      required this.onDeleteClick,
      required this.onItemClick});

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => data.length;
  @override
  int get selectedRowCount => 0;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);

    final dataItem = data[index];

    return DataRow.byIndex(
      index: index,
      selected: false,
      cells: <DataCell>[
        DataCell(
          Text(dataItem.productCode),
          onTap: () => onItemClick(dataItem),
        ),
        DataCell(
          SizedBox(
              width: 150,
              child: Tooltip(
                  message: dataItem.productDescription,
                  child: Text(
                    dataItem.productName,
                    overflow: TextOverflow.ellipsis,
                  ))),
          onTap: () => onItemClick(dataItem),
        ),
        // DataCell(
        //   SizedBox(
        //     width: 150,
        //     child: Tooltip(
        //         message: dataItem.productDescription,
        //         child: Text(
        //           dataItem.productDescription,
        //           overflow: TextOverflow.ellipsis,
        //         )),
        //   ),
        //   onTap: () => onItemClick(dataItem),
        // ),
        DataCell(
          Text(dataItem.category.categoryName),
          onTap: () => onItemClick(dataItem),
        ),
        DataCell(
          Text(dataItem.productPrice.toString()),
          onTap: () => onItemClick(dataItem),
        ),
        DataCell(
          SizedBox(
              width: 60,
              child: Text(
                dataItem.productQuantity.toString(),
              )),
          onTap: () => onItemClick(dataItem),
        ),
        DataCell(
          Text(dataItem.productUnit),
          onTap: () => onItemClick(dataItem),
        ),

        DataCell(
          Text(dataItem.supplier.supplierName),
          onTap: () => onItemClick(dataItem),
        ),
        // DataCell(Text('${dataItem.productId}')),
        DataCell(
            const Icon(
              Icons.delete,
              color: Color.fromARGB(255, 92, 13, 6),
            ),
            onTap: () => onDeleteClick(dataItem.productId!)),
      ],
    );
  }
}
