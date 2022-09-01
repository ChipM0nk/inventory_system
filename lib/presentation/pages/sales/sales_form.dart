import 'package:flutter/material.dart';

import '../../../data/model/invoice_item_model.dart';
import '../../../data/model/product.dart';
import '../../utils/validators.dart';
import '../../widgets/form_field.dart';
import 'add_item_dialog.dart';

class SalesForm extends StatefulWidget {
  const SalesForm({Key? key}) : super(key: key);

  @override
  State<SalesForm> createState() => _SalesFormState();
}

class _SalesFormState extends State<SalesForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final invoiceNo = TextEditingController();
  final customerName = TextEditingController();
  final customerAddress = TextEditingController();
  final contactNumber = TextEditingController();
  final salesPerson = TextEditingController();
  final poNumber = TextEditingController();
  final purchaseDate = TextEditingController(); //changet to date picker later
  final paymentTyoe = TextEditingController();
  final paymentTerms = TextEditingController();
  final tinNo = TextEditingController();
  final dueDate = TextEditingController(); //cahgnet to date picker later

  InvoiceItemModel invoiceItem = InvoiceItemModel();
  List<InvoiceItemModel> invoiceItems = [];

  @override
  void initState() {
    // Product product = Product();
    // product.productId = 1;
    // product.productName = "bowl";
    // invoiceItem.product = product;
    // invoiceItem.sellPrice = 2.00;
    // invoiceItem.quantity = 1;

    invoiceItems.add(invoiceItem);

    super.initState();
  }

  void addInvoiceItem(invoiceItem) {
    setState(() {
      invoiceItems.add(invoiceItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        child: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    CustomTextFormField(
                        validator: (value) => Validators.stringNotEmpty(value),
                        fieldName: 'Invoice No',
                        controller: invoiceNo),
                    CustomTextFormField(
                        validator: (value) => Validators.stringNotEmpty(value),
                        fieldName: "Customer Name",
                        controller: customerName),
                    CustomTextFormField(
                        validator: (value) => Validators.stringNotEmpty(value),
                        fieldName: "Customer Address",
                        controller: customerAddress),
                    CustomTextFormField(
                        validator: (value) => Validators.stringNotEmpty(value),
                        fieldName: "Contact No.",
                        controller: contactNumber),
                    CustomTextFormField(
                        validator: (value) => Validators.stringNotEmpty(value),
                        fieldName: "Sales Person",
                        controller: salesPerson),
                  ],
                ),
                SizedBox(
                  width: 50,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    CustomTextFormField(
                        validator: (value) => Validators.stringNotEmpty(value),
                        fieldName: "Invoice No.",
                        controller: invoiceNo),
                    CustomTextFormField(
                        validator: (value) => Validators.stringNotEmpty(value),
                        fieldName: "Customer Name",
                        controller: customerName),
                    CustomTextFormField(
                        validator: (value) => Validators.stringNotEmpty(value),
                        fieldName: "Customer Address",
                        controller: customerAddress),
                    CustomTextFormField(
                        validator: (value) => Validators.stringNotEmpty(value),
                        fieldName: "Contact No.",
                        controller: contactNumber),
                    CustomTextFormField(
                        validator: (value) => Validators.stringNotEmpty(value),
                        fieldName: "Sales Person",
                        controller: salesPerson),
                    CustomTextFormField(
                        validator: (value) => Validators.stringNotEmpty(value),
                        fieldName: "Sales Person",
                        controller: salesPerson),
                  ],
                )
              ]),
          Expanded(
              child: Align(
            alignment: Alignment.topLeft,
            child: DataTable(
              columns: <DataColumn>[
                DataColumn(
                  label: Text(
                    'Item Name',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Item Code',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Quantity',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Price',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ],
              rows: invoiceItems
                  .map((iv) => DataRow(cells: [
                        DataCell(Text((iv.product.productId).toString())),
                        DataCell(Text(iv.product.productName)),
                        DataCell(Text(iv.sellPrice.toString())),
                        DataCell(Text(iv.quantity.toString())),
                      ]))
                  .toList(),
            ),
          )),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  child: Text("Open Popup"),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Container();
                          // return AddItemDialog(
                          //   addInvoiceItem: addInvoiceItem,
                          // );
                        });
                  },
                ),
              )
            ],
          )
        ],
      ),
    ));
  }
}
