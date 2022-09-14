// import 'package:edar_app/cubit/purchases/purchase_cubit.dart';
// import 'package:edar_app/data/model/purchase.dart';
// import 'package:edar_app/presentation/datasource/purchase_datasource.dart';
// import 'package:edar_app/presentation/pages/purchase/purchase_dialog.dart';
// import 'package:edar_app/presentation/widgets/custom_paginated_datatable.dart';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class PurchasePage extends StatefulWidget {
//   const PurchasePage({Key? key}) : super(key: key);

//   @override
//   State<PurchasePage> createState() => _PurchasePageState();
// }

// class _PurchasePageState extends State<PurchasePage> {
//   final searchController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//         width: 1500,
//         height: 1000,
//         child: BlocBuilder<PurchaseCubit, PurchaseState>(
//           builder: (context, state) {
//             if (state is! PurchaseLoaded) {
//               if (state is PurchaseInitial) {
//                 BlocProvider.of<PurchaseCubit>(context).fetchPurchase();
//               }
//               return const Center(child: CircularProgressIndicator());
//             }

//             PurchaseData purchaseData = PurchaseData(
//                 data: state.filteredData ?? state.purchase,
//                 onDeleteClick: _deletePurchase,
//                 onItemClick: _openUpdatePurchaseDialog);
//             return Column(children: [
//               Row(
//                 children: [
//                   SizedBox(
//                     height: 20,
//                     width: 350,
//                     child: TextField(
//                         controller: searchController,
//                         decoration: const InputDecoration(
//                           hintText: 'Search',
//                         ),
//                         onChanged: (value) => {
//                               BlocProvider.of<PurchaseCubit>(context)
//                                   .searchPurchase(value),
//                             }),
//                   ),
//                   const SizedBox(
//                     width: 30,
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       showDialog(
//                           context: context,
//                           builder: (_) {
//                             searchController.clear();
//                             return BlocProvider.value(
//                               value: context.read<PurchaseCubit>(),
//                               child: PurchaseDialog(),
//                             );
//                           });
//                     },
//                     child: const Text("Add Purchase"),
//                   ),
//                 ],
//               ),
//               Align(
//                 alignment: Alignment.topLeft,
//                 child: SizedBox(
//                   width: 800,
//                   child: CustomPaginatedDataTable(
//                       header: const Text("Purchase"),
//                       dataColumns: dataColumns(purchaseData),
//                       rowsPerPage: 10,
//                       sortAscending: state.sortAscending,
//                       sortIndex: state.sortIndex,
//                       source: purchaseData),
//                 ),
//               ),
//             ]);
//           },
//         ));
//   }

//   List<DataColumn> dataColumns(PurchaseData data) => <DataColumn>[
//         DataColumn(
//           label: const Text(
//             'Purchase No',
//             style: TextStyle(
//                 fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
//           ),
//           onSort: (colIdx, asc) {
//             BlocProvider.of<PurchaseCubit>(context)
//                 .sortPurchase((purchase) => purchase.purchaseNo, colIdx, asc);
//           },
//         ),
//         DataColumn(
//           label: const Text(
//             'Batch Code',
//             style: TextStyle(
//                 fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
//           ),
//           onSort: (colIdx, asc) {
//             BlocProvider.of<PurchaseCubit>(context)
//                 .sortPurchase((purchase) => purchase.batchCode, colIdx, asc);
//           },
//         ),
//         DataColumn(
//           label: const Text(
//             'Product',
//             style: TextStyle(
//                 fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
//           ),
//           onSort: (colIdx, asc) {
//             BlocProvider.of<PurchaseCubit>(context).sortPurchase(
//                 (purchase) => purchase.product.productName, colIdx, asc);
//           },
//         ),
//         DataColumn(
//           label: const Text(
//             'Supplier',
//             style: TextStyle(
//                 fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
//           ),
//           onSort: (colIdx, asc) {
//             BlocProvider.of<PurchaseCubit>(context).sortPurchase(
//                 (purchase) => purchase.product.supplier.supplierName,
//                 colIdx,
//                 asc);
//           },
//         ),
//         DataColumn(
//           label: const Text(
//             'Purchase Date',
//             style: TextStyle(
//                 fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
//           ),
//           onSort: (colIdx, asc) {
//             BlocProvider.of<PurchaseCubit>(context)
//                 .sortPurchase((purchase) => purchase.purchaseDate, colIdx, asc);
//           },
//         ),
//         const DataColumn(
//           label: Text(''),
//         ),
//       ];

//   void _deletePurchase(int purchaseId) {
//     print('deleting purchase : ${purchaseId}');

//     searchController.clear();
//     showDialog(
//         context: context,
//         builder: (_) {
//           return BlocProvider.value(
//             value: context.read<PurchaseCubit>(),
//             child: AlertDialog(
//               title: Text("Delete"),
//               content: BlocListener<PurchaseCubit, PurchaseState>(
//                 listener: (context, state) {
//                   if (state is PurchaseDeleted) {
//                     Navigator.of(context, rootNavigator: true).pop();
//                   }
//                 },
//                 child: Text("Are you sure you want to delete this item?"),
//               ),
//               actions: [
//                 ElevatedButton(
//                     child: Text("Yes"),
//                     onPressed: () {
//                       BlocProvider.of<PurchaseCubit>(context)
//                           .deletePurchase(purchaseId);
//                     }),
//                 ElevatedButton(
//                     child: Text("No"),
//                     onPressed: () {
//                       Navigator.of(context, rootNavigator: true).pop();
//                     }),
//               ],
//             ),
//           );
//         });
//   }

//   void _openUpdatePurchaseDialog(Purchase purchase) {
//     print('updating purchase : ${purchase.purchaseNo}');
//     searchController.clear();
//     showDialog(
//         context: context,
//         builder: (_) {
//           return BlocProvider.value(
//             value: context.read<PurchaseCubit>(),
//             child: PurchaseDialog(purchase: purchase),
//           );
//         });
//   }
// }
