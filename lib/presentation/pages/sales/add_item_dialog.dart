// import 'package:flutter/material.dart';

// import '../../../data/model/invoice_item_model.dart';
// import '../../../data/model/product.dart';

// class AddItemDialog extends StatefulWidget {
//   final Function(InvoiceItemModel) addInvoiceItem;
//   const AddItemDialog({
//     Key? key,
//     required this.addInvoiceItem,
//   }) : super(key: key);
//   @override
//   State<AddItemDialog> createState() => _AddItemDialogState();
// }

// class _AddItemDialogState extends State<AddItemDialog> {
//   @override
//   Widget build(BuildContext context) {
//     final itemName = TextEditingController();
//     final itemCode = TextEditingController();
//     final quantity = TextEditingController();
//     final price = TextEditingController();

//     return AlertDialog(
//       scrollable: true,
//       title: Text('Add Item'),
//       content: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Form(
//           child: Column(
//             children: <Widget>[
//               TextFormField(
//                 decoration: InputDecoration(
//                   labelText: 'Item Name',
//                 ),
//                 controller: itemName,
//               ),
//               TextFormField(
//                 decoration: InputDecoration(
//                   labelText: 'Item Code',
//                 ),
//                 controller: itemCode,
//               ),
//               TextFormField(
//                 decoration: InputDecoration(
//                   labelText: 'Quantity',
//                 ),
//                 controller: quantity,
//               ),
//               TextFormField(
//                 decoration: InputDecoration(
//                   labelText: 'Price',
//                 ),
//                 controller: price,
//               ),
//             ],
//           ),
//         ),
//       ),
//       actions: [
//         ElevatedButton(
//             child: Text("Submit"),
//             onPressed: () {
//               InvoiceItemModel invoiceItem = InvoiceItemModel();
//               Product product = Product();
//               product.productId = int.parse(itemCode.text);
//               product.productName = itemName.text;

//               invoiceItem.product = product;
//               invoiceItem.sellPrice = double.parse(price.text);
//               invoiceItem.quantity = double.parse(quantity.text);
//               widget.addInvoiceItem(invoiceItem);
//               Navigator.of(context).pop();
//             })
//       ],
//     );
//   }
// }
