// import 'package:edar_app/data/model/purchase.dart';
// import 'package:flutter/material.dart';

// typedef OnRowSelect = void Function(int index);
// typedef OnDeleteClick = void Function(int index);
// typedef OnItemClick = void Function(Purchase purchase);

// class PurchaseData extends DataTableSource {
//   final List<Purchase> data;
//   final OnDeleteClick onDeleteClick;
//   final OnItemClick onItemClick;

//   PurchaseData(
//       {required this.data,
//       required this.onDeleteClick,
//       required this.onItemClick});

//   @override
//   bool get isRowCountApproximate => false;
//   @override
//   int get rowCount => data.length;
//   @override
//   int get selectedRowCount => 0;

//   @override
//   DataRow getRow(int index) {
//     assert(index >= 0);

//     final dataItem = data[index];

//     return DataRow.byIndex(
//       index: index,
//       selected: false,
//       cells: <DataCell>[
//         DataCell(
//           Text(dataItem.purchaseNo),
//           onTap: () => onItemClick(dataItem),
//         ),
//         DataCell(
//           Text(dataItem.batchCode),
//           onTap: () => onItemClick(dataItem),
//         ),
//         DataCell(
//           Text(dataItem.product.productName),
//           onTap: () => onItemClick(dataItem),
//         ),
//         DataCell(
//           Text(dataItem.product.supplier.supplierName),
//           onTap: () => onItemClick(dataItem),
//         ),
//         DataCell(
//           Text(dataItem.purchaseDate),
//           onTap: () => onItemClick(dataItem),
//         ),
//         //TODO: Add button to get the total products in the batchCode
//         // DataCell(Text('${dataItem.purchaseId}')),
//         DataCell(
//             const Icon(
//               Icons.delete,
//               color: Color.fromARGB(255, 92, 13, 6),
//             ),
//             onTap: () => onDeleteClick(dataItem.purchaseId!)),
//       ],
//     );
//   }
// }
