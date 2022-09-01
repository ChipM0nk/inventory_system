// import 'package:flutter/material.dart';

// class SalesForm extends StatefulWidget {
//   const SalesForm();

//   @override
//   State<SalesForm> createState() => _SalesFormState();
// }

// class _SalesFormState extends State<SalesForm> {
//   final invoiceNo = TextEditingController();
//   final customerName = TextEditingController();
//   final customerAddress = TextEditingController();
//   final contactNumber = TextEditingController();
//   final salesPerson = TextEditingController();
//   final poNumber = TextEditingController();
//   final purchaseDate = TextEditingController(); //changet to date picker later
//   final paymentTyoe = TextEditingController();
//   final paymentTerms = TextEditingController();
//   final tinNo = TextEditingController();
//   final dueDate = TextEditingController(); //cahgnet to date picker later
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Row(children: [
//         Column(
//           children: [
//             Container(
//                 child: Row(
//               children: [
//                 ListTile(
//                   leading: const Text("Invoice No:"),
//                   title: TextFormField(
//                     decoration: const InputDecoration(hintText: 'Invoice No'),
//                     controller: invoiceNo,
//                   ),
//                 ),
//                 ListTile(
//                   leading: const Text("Customer Name"),
//                   title: TextFormField(
//                     decoration:
//                         const InputDecoration(hintText: 'Customer Name'),
//                     controller: customerName,
//                   ),
//                 )
//               ],
//             )),
//             Container(
//                 child: Row(
//               children: [
//                 ListTile(
//                   leading: const Text("PO Number"),
//                   title: TextFormField(
//                     decoration: const InputDecoration(hintText: 'PO Number'),
//                     controller: poNumber,
//                   ),
//                 ),
//                 ListTile(
//                   leading: const Text("Purchase Date"),
//                   title: TextFormField(
//                     decoration: const InputDecoration(hintText: 'PurchaseDate'),
//                     controller: purchaseDate,
//                   ),
//                 )
//               ],
//             ))
//           ],
//         ),
//         Container()
//       ]),
//     );
//   }
// }
