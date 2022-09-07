import 'package:edar_app/cubit/invoice/invoice_cubit.dart';
import 'package:edar_app/cubit/products/products_cubit.dart';
import 'package:edar_app/data/model/category.dart';
import 'package:edar_app/data/model/invoice_item.dart';
import 'package:edar_app/data/model/supplier.dart';
import 'package:edar_app/presentation/widgets/fields/custom_date_picker.dart';
import 'package:edar_app/presentation/widgets/fields/custom_dropdown.dart';
import 'package:edar_app/presentation/widgets/fields/error_message_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/invoice_item_model.dart';
import '../../../data/model/product.dart';

import '../../widgets/fields/custom_text_field.dart';
import 'add_item_dialog.dart';

class SalesForm extends StatefulWidget {
  const SalesForm({Key? key}) : super(key: key);

  @override
  State<SalesForm> createState() => _SalesFormState();
}

class _SalesFormState extends State<SalesForm> {
  final dateFormat = 'dd-MMM-yy';
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

    BlocProvider.of<InvoiceCubit>(context).init();
    BlocProvider.of<InvoiceCubit>(context).updatePaymentTerm('Cash');

    super.initState();
  }

  void addInvoiceItem(invoiceItem) {
    setState(() {
      invoiceItems.add(invoiceItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    var invoiceNumber = StreamBuilder<String>(
        stream: BlocProvider.of<InvoiceCubit>(context).invoiceNumberStream,
        builder: (context, snapshot) {
          return Column(
            children: [
              CustomTextField(
                  onChanged: (text) {
                    BlocProvider.of<InvoiceCubit>(context)
                        .updateInvoiceNumber(text);
                  },
                  labelText: 'Invoice No'),
              ErrorMessage(snapshot: snapshot),
            ],
          );
        });

    var customerName = StreamBuilder<String>(
        stream: BlocProvider.of<InvoiceCubit>(context).customerNameStream,
        builder: (context, snapshot) {
          return Column(
            children: [
              CustomTextField(
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
              CustomTextField(
                  onChanged: (text) {
                    BlocProvider.of<InvoiceCubit>(context)
                        .updateCustomerContact(text);
                  },
                  labelText: 'Contact Number'),
              ErrorMessage(snapshot: snapshot)
            ],
          );
        });

    var customerAddressField = StreamBuilder<String>(
      stream: BlocProvider.of<InvoiceCubit>(context).customerAddressStream,
      builder: (context, snapshot) {
        return Column(
          children: [
            CustomTextField(
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

    var purchaseDate = Column(
      children: [
        CustomDatePicker(
          labelText: "Purchase Date",
          // selectedDate: selectedDate,
          width: 175,
          onChanged: (dateTime) {
            BlocProvider.of<InvoiceCubit>(context).updatePurchaseDate(dateTime);
          },
          // initialValue: '21-Sep-22',
          dateFormat: dateFormat,
        ),
      ],
    );

    var paymentType = StreamBuilder<String>(
        stream: BlocProvider.of<InvoiceCubit>(context).paymentTermStream,
        builder: (context, snapshot) {
          void onPaymentTermChange<String>(val) {
            BlocProvider.of<InvoiceCubit>(context).updatePaymentTerm(val);
          }

          return Column(
            children: [
              CustomDropdown<String>(
                labelText: "Payment Type",
                value: BlocProvider.of<InvoiceCubit>(context).getPaymentTerm(),
                items: const [
                  //TODO: Put in constant
                  DropdownMenuItem<String>(
                    value: 'Cash',
                    child: Text('Cash'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Cheque',
                    child: Text('Cheque'),
                  ),
                ],
                context: context,
                onChanged: onPaymentTermChange,
              ),
            ],
          );
        });

    var poNumber = StreamBuilder<String>(
        stream: BlocProvider.of<InvoiceCubit>(context).poNumberStream,
        builder: (context, snapshot) {
          return Column(
            children: [
              CustomTextField(
                  onChanged: (text) {
                    BlocProvider.of<InvoiceCubit>(context).updatePoNumber(text);
                  },
                  labelText: 'PO Number'),
              ErrorMessage(snapshot: snapshot)
            ],
          );
        });

    var dueDate = Column(
      children: [
        CustomDatePicker(
          labelText: "Due Date",
          // selectedDate: selectedDate,
          width: 175,
          onChanged: (dateTime) {
            BlocProvider.of<InvoiceCubit>(context).updateDueDate(dateTime);
          },
          // initialValue: '21-Sep-22',
          dateFormat: dateFormat,
        ),
      ],
    );

    var tinNumber = StreamBuilder<String>(
        stream: BlocProvider.of<InvoiceCubit>(context).tinNumberStream,
        builder: (context, snapshot) {
          return Column(
            children: [
              CustomTextField(
                  onChanged: (text) {
                    BlocProvider.of<InvoiceCubit>(context)
                        .updateTinNumber(text);
                  },
                  labelText: 'TIN Number'),
              ErrorMessage(snapshot: snapshot)
            ],
          );
        });

    var invoiceItemDataTable = StreamBuilder<List<InvoiceItem>>(
        stream: BlocProvider.of<InvoiceCubit>(context).invoiceItemsStream,
        builder: (context, snapshot) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
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
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
              columns: const <DataColumn>[
                DataColumn(
                  label: Text(
                    'SN',
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: SizedBox(
                    width: 150,
                    child: Text(
                      'Product Name',
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                DataColumn(
                  label: SizedBox(
                    width: 250,
                    child: Text(
                      'Product Description',
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                DataColumn(
                  label: SizedBox(
                    width: 60,
                    child: Text(
                      'Quantity',
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Unit',
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Price',
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Total',
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
              rows: BlocProvider.of<InvoiceCubit>(context)
                  .getInvoiceItems()!
                  .map((iv) => DataRow(cells: [
                        DataCell(Text((iv.product.productId).toString())),
                        DataCell(Text(iv.product.productName)),
                        DataCell(Text(iv.quantity.toString())),
                        DataCell(Text(iv.quantity.toString())),
                        DataCell(Text(iv.quantity.toString())),
                        DataCell(Text(iv.quantity.toString())),
                        DataCell(Text(iv.quantity.toString())),
                      ]))
                  .toList(),
            ),
          );
        });
    return SizedBox(
      width: 1800,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 960,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    invoiceNumber,
                    customerName,
                    customerAddressField,
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customerContactNumber,
                    purchaseDate,
                    poNumber,
                    dueDate,
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    tinNumber,
                    paymentType,
                    const Padding(
                        padding: EdgeInsets.all(5.0),
                        child: SizedBox(width: 200)),
                    const Padding(
                        padding: EdgeInsets.all(5.0),
                        child: SizedBox(width: 200)),
                  ],
                ),
              ],
            ),
          ),
          invoiceItemDataTable,
          GestureDetector(
            child: const Icon(
              Icons.add_box_outlined,
              color: Colors.green,
              size: 25,
            ),
            onTap: () {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (_) {
                    return MultiBlocProvider(
                      providers: [
                        BlocProvider.value(
                            value: context.read<ProductsCubit>()),
                        BlocProvider.value(value: context.read<InvoiceCubit>()),
                      ],
                      child: AddItemDialog(
                        addInvoiceItem: addInvoiceItem,
                      ),
                    );
                  });
            },
          ),
          Row(
            children: [
              Expanded(child: Container()
                  // ElevatedButton(
                  //   child: Text("Open Popup"),
                  //   onPressed: () {
                  //     showDialog(
                  //         context: context,
                  //         builder: (BuildContext context) {
                  //           return Container();
                  //           // return AddItemDialog(
                  //           //   addInvoiceItem: addInvoiceItem,
                  //           // );
                  //         });
                  //   },
                  // ),
                  )
            ],
          )
        ],
      ),
    );
  }
}
