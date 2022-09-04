import 'package:edar_app/cubit/invoice/invoice_cubit.dart';
import 'package:edar_app/data/model/category.dart';
import 'package:edar_app/data/model/invoice.dart';
import 'package:edar_app/data/model/supplier.dart';
import 'package:edar_app/presentation/widgets/fields/date_picker.dart';
import 'package:edar_app/presentation/widgets/fields/error_message_field.dart';
import 'package:edar_app/presentation/widgets/fields/error_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/invoice_item_model.dart';
import '../../../data/model/product.dart';

import '../../widgets/fields/form_field.dart';
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
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    // Product product = Product();
    // product.productId = 1;
    // product.productName = "bowl";

    Product product = const Product(
      productCode: "code",
      productName: "name",
      productDescription: "productDescription",
      productPrice: 12.99,
      productQuantity: 12.99,
      productUnit: "productUnit",
      supplier: Supplier(
          supplierName: "name",
          supplierContactNumber: "sds",
          supplierEmailAdd: "dsf@dfds",
          supplierAddress: "ass"),
      category: Category(
        categoryCode: "code",
        categoryName: "name",
      ),
    );
    invoiceItem.product = product;
    invoiceItem.sellPrice = 2.00;
    invoiceItem.quantity = 1;

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
    BlocProvider.of<InvoiceCubit>(context).init();

    var invoiceNumber = StreamBuilder<String>(
        stream: BlocProvider.of<InvoiceCubit>(context).invoiceNumberStream,
        builder: (context, snapshot) {
          return Column(
            children: [
              CustomTextFormField(
                  onChanged: (text) {
                    BlocProvider.of<InvoiceCubit>(context)
                        .updateInvoiceNumber(text);
                  },
                  labelText: 'Invoice No'),
              snapshot.hasError
                  ? ErrorText(errorText: snapshot.error.toString())
                  : const SizedBox(
                      height: 10,
                    )
            ],
          );
        });

    var poNumber = StreamBuilder<String>(
        stream: BlocProvider.of<InvoiceCubit>(context).poNumberStream,
        builder: (context, snapshot) {
          return Column(
            children: [
              CustomTextFormField(
                  onChanged: (text) {
                    BlocProvider.of<InvoiceCubit>(context).updatePoNumber(text);
                  },
                  labelText: 'PO Number'),
              ErrorMessage(snapshot: snapshot)
            ],
          );
        });
    var customerName = StreamBuilder<String>(
        stream: BlocProvider.of<InvoiceCubit>(context).customerNameStream,
        builder: (context, snapshot) {
          return Column(
            children: [
              CustomTextFormField(
                  onChanged: (text) {
                    BlocProvider.of<InvoiceCubit>(context)
                        .updateCustomerName(text);
                  },
                  labelText: 'Customer Name'),
              ErrorMessage(snapshot: snapshot)
            ],
          );
        });
    var customerContactNumber = StreamBuilder<String>(
        stream: BlocProvider.of<InvoiceCubit>(context).customerContactStream,
        builder: (context, snapshot) {
          return Column(
            children: [
              CustomTextFormField(
                  onChanged: (text) {
                    BlocProvider.of<InvoiceCubit>(context)
                        .updateCustomerContact(text);
                  },
                  labelText: 'Contact Number'),
              ErrorMessage(snapshot: snapshot)
            ],
          );
        });

    var customerAddressField = StreamBuilder(
      stream: BlocProvider.of<InvoiceCubit>(context).customerAddressStream,
      builder: (context, snapshot) {
        return Column(
          children: [
            CustomTextFormField(
                labelText: "Customer Address",
                hintText: "Sto Tomas",
                textInputType: TextInputType.multiline,
                width: 450,
                minLines: 1,
                onChanged: (text) {
                  BlocProvider.of<InvoiceCubit>(context)
                      .updateCustomerAddress(text);
                }),
            ErrorMessage(snapshot: snapshot)
          ],
        );
      },
    );
    return SizedBox(
      width: 1800,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 720,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    invoiceNumber,
                    customerName,
                    customerContactNumber,
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customerAddressField,
                    Column(
                      children: [
                        CustomDatePicker(
                          labelText: "Purchase Date",
                          // selectedDate: selectedDate,
                          width: 175,
                          onChanged: (text) {
                            print("updated: ${text}");
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        )
                      ],
                    )
                    // ElevatedButton(
                    //   onPressed: () => _selectDate(context),
                    //   child: Text('Select date'),
                    // ),
                  ],
                ),
                Row(
                  children: [
                    customerName,
                    poNumber,
                    const SizedBox(
                      width: 30,
                    ),
                  ],
                ),

                // Column(
                //   mainAxisSize: MainAxisSize.min,
                //   children: <Widget>[
                //     invoiceNumber,
                //     CustomTextFormField(
                //         validator: (value) => Validators.stringNotEmpty(value),
                //         labelText: "Customer Name",
                //         controller: customerName),
                //     CustomTextFormField(
                //         validator: (value) => Validators.stringNotEmpty(value),
                //         labelText: "Customer Address",
                //         controller: customerAddress),
                //     CustomTextFormField(
                //         validator: (value) => Validators.stringNotEmpty(value),
                //         labelText: "Contact No.",
                //         controller: contactNumber),
                //     CustomTextFormField(
                //         validator: (value) => Validators.stringNotEmpty(value),
                //         labelText: "Sales Person",
                //         controller: salesPerson),
                //   ],
                // ),
                // const SizedBox(
                //   width: 50,
                // ),
                // Column(
                //   mainAxisSize: MainAxisSize.min,
                //   children: <Widget>[
                //     CustomTextFormField(
                //         validator: (value) => Validators.stringNotEmpty(value),
                //         labelText: "Invoice No.",
                //         controller: invoiceNo),
                //     CustomTextFormField(
                //         validator: (value) => Validators.stringNotEmpty(value),
                //         labelText: "Customer Name",
                //         controller: customerName),
                //     CustomTextFormField(
                //         validator: (value) => Validators.stringNotEmpty(value),
                //         labelText: "Customer Address",
                //         controller: customerAddress),
                //     CustomTextFormField(
                //         validator: (value) => Validators.stringNotEmpty(value),
                //         labelText: "Contact No.",
                //         controller: contactNumber),
                //     CustomTextFormField(
                //         validator: (value) => Validators.stringNotEmpty(value),
                //         labelText: "Sales Person",
                //         controller: salesPerson),
                //     CustomTextFormField(
                //         validator: (value) => Validators.stringNotEmpty(value),
                //         labelText: "Sales Person",
                //         controller: salesPerson),
                //   ],
                // )
              ],
            ),
          ),
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
    );
  }
}
