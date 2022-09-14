// import 'package:edar_app/cubit/purchases/purchase_cubit.dart';
// import 'package:edar_app/data/model/purchase.dart';
// import 'package:edar_app/presentation/widgets/fields/custom_text_field.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// // ignore: must_be_immutable
// class PurchaseDialog extends StatelessWidget {
//   Purchase? purchase;
//   PurchaseDialog({this.purchase, Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     String title = 'Add Purchase';
//     int? purchaseId;
//     BlocProvider.of<PurchaseCubit>(context).init();

//     if (purchase != null) {
//       BlocProvider.of<PurchaseCubit>(context).loadPurchase(purchase!);
//       title = 'Update Purchase';
//       purchaseId = purchase!.purchaseId;
//     }

//     var purchaseNo = StreamBuilder(
//       stream: BlocProvider.of<PurchaseCubit>(context).purchaseNoStream,
//       builder: (context, snapshot) {
//         return Padding(
//           padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
//           child: CustomTextField(
//               labelText: "Purchase Code",
//               hintText: "BWLS",
//               initialValue:
//                   purchase != null ? purchase!.purchaseNo.toString() : null,
//               snapshot: snapshot,
//               onChanged: (text) {
//                 BlocProvider.of<PurchaseCubit>(context).updatePurchaseNo(text);
//               }),
//         );
//       },
//     );

//     var purchaseDate = StreamBuilder(
//       stream: BlocProvider.of<PurchaseCubit>(context).purchaseDateStream,
//       builder: (context, snapshot) {
//         return Padding(
//           padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
//           child: CustomTextField(
//               labelText: "Purchase Name",
//               hintText: "Toilet Bowls",
//               initialValue:
//                   purchase != null ? purchase!.purchaseName.toString() : null,
//               snapshot: snapshot,
//               onChanged: (text) {
//                 BlocProvider.of<PurchaseCubit>(context)
//                     .updatePurchaseName(text);
//               }),
//         );
//       },
//     );
//     return AlertDialog(
//       scrollable: true,
//       title: Text(title),
//       content: BlocListener<PurchaseCubit, CategoriesState>(
//           listener: (context, state) {
//             if (state is PurchaseAdded || state is PurchaseUpdated) {
//               Navigator.of(context, rootNavigator: true).pop();
//             }
//           },
//           child: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 Column(
//                   children: [
//                     purchaseCode,
//                     purchaseName,
//                   ],
//                 ),
//               ],
//             ),
//           )),
//       actions: [
//         StreamBuilder(
//           stream: BlocProvider.of<PurchaseCubit>(context).buttonValid,
//           builder: (context, snapshot) {
//             return Padding(
//               padding: const EdgeInsets.all(24),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF08B578),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                       ),
//                       onPressed: snapshot.hasData
//                           ? purchase == null
//                               ? () => BlocProvider.of<PurchaseCubit>(context)
//                                   .addPurchase()
//                               : () => BlocProvider.of<PurchaseCubit>(context)
//                                   .updatePurchase(purchaseId!)
//                           : null,
//                       child: const Text(
//                         "Submit",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ],
//     );
//   }
// }
