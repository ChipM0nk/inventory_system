import 'package:edar_app/cubit/invoice/invoice_cubit.dart';
import 'package:edar_app/cubit/products/products_cubit.dart';

import 'package:edar_app/data/model/invoice_item.dart';
import 'package:edar_app/presentation/widgets/fields/custom_date_picker.dart';
import 'package:edar_app/presentation/widgets/fields/custom_dropdown.dart';
import 'package:edar_app/presentation/widgets/fields/custom_label_text_field.dart';
import 'package:edar_app/presentation/widgets/fields/numeric_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/invoice_item_model.dart';

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
  final totalAmountController = TextEditingController();

  @override
  void initState() {
    BlocProvider.of<InvoiceCubit>(context).init();
    BlocProvider.of<InvoiceCubit>(context).updatePaymentTerm('Cash');
    totalAmountController.text = "0.0";

    super.initState();
  }

  void _addItem(InvoiceItem invoiceItem) {
    double totalAmount =
        double.parse(totalAmountController.text) + invoiceItem.amount;
    BlocProvider.of<InvoiceCubit>(context).addInvoiceItem(invoiceItem);

    BlocProvider.of<InvoiceCubit>(context).updateTotalAmount(totalAmount);
    totalAmountController.text = totalAmount.toString();
  }

  void _deleteItem(InvoiceItem invoiceItem) {
    double totalAmount =
        double.parse(totalAmountController.text) - invoiceItem.amount;

    BlocProvider.of<InvoiceCubit>(context).removeInvoiceItem(invoiceItem);
    BlocProvider.of<InvoiceCubit>(context).updateTotalAmount(totalAmount);
    totalAmountController.text = totalAmount.toString();
  }

  @override
  Widget build(BuildContext context) {
    var invoiceNumber = StreamBuilder<String>(
        stream: BlocProvider.of<InvoiceCubit>(context).invoiceNumberStream,
        builder: (context, snapshot) {
          return CustomTextField(
              snapshot: snapshot,
              onChanged: (text) {
                BlocProvider.of<InvoiceCubit>(context)
                    .updateInvoiceNumber(text);
              },
              labelText: 'Invoice No');
        });

    var customerName = StreamBuilder<String>(
        stream: BlocProvider.of<InvoiceCubit>(context).customerNameStream,
        builder: (context, snapshot) {
          return CustomTextField(
              snapshot: snapshot,
              onChanged: (text) {
                BlocProvider.of<InvoiceCubit>(context).updateCustomerName(text);
              },
              labelText: 'Customer Name');
        });
    var customerContactNumber = StreamBuilder<String>(
        stream: BlocProvider.of<InvoiceCubit>(context).customerContactStream,
        builder: (context, snapshot) {
          return CustomTextField(
              snapshot: snapshot,
              onChanged: (text) {
                BlocProvider.of<InvoiceCubit>(context)
                    .updateCustomerContact(text);
              },
              labelText: 'Contact Number');
        });

    var customerAddressField = StreamBuilder<String>(
      stream: BlocProvider.of<InvoiceCubit>(context).customerAddressStream,
      builder: (context, snapshot) {
        return CustomTextField(
            labelText: "Customer Address",
            hintText: "Sto Tomas",
            textInputType: TextInputType.multiline,
            width: 450,
            minLines: 1,
            snapshot: snapshot,
            onChanged: (text) {
              BlocProvider.of<InvoiceCubit>(context)
                  .updateCustomerAddress(text);
            });
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

          return CustomDropdown<String>(
            labelText: "Payment Type",
            value: BlocProvider.of<InvoiceCubit>(context).getPaymentType(),
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
          );
        });

    var poNumber = StreamBuilder<String>(
        stream: BlocProvider.of<InvoiceCubit>(context).poNumberStream,
        builder: (context, snapshot) {
          return CustomTextField(
              snapshot: snapshot,
              onChanged: (text) {
                BlocProvider.of<InvoiceCubit>(context).updatePoNumber(text);
              },
              labelText: 'PO Number');
        });

    var dueDate = CustomDatePicker(
      labelText: "Due Date",
      // selectedDate: selectedDate,
      width: 175,
      onChanged: (dateTime) {
        BlocProvider.of<InvoiceCubit>(context).updateDueDate(dateTime);
      },
      // initialValue: '21-Sep-22',
      dateFormat: dateFormat,
    );

    var tinNumber = StreamBuilder<String>(
        stream: BlocProvider.of<InvoiceCubit>(context).tinNumberStream,
        builder: (context, snapshot) {
          return CustomTextField(
              snapshot: snapshot,
              onChanged: (text) {
                BlocProvider.of<InvoiceCubit>(context).updateTinNumber(text);
              },
              labelText: 'TIN Number');
        });

    var paymentTerm = StreamBuilder<String>(
        stream: BlocProvider.of<InvoiceCubit>(context).paymentTermStream,
        builder: (context, snapshot) {
          return CustomTextField(
              snapshot: snapshot,
              onChanged: (text) {
                BlocProvider.of<InvoiceCubit>(context).updatePaymentTerm(text);
              },
              labelText: 'Payment Term');
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
                      'Price',
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
                  label: SizedBox(
                    width: 40,
                    child: Text(
                      'Unit',
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
                      'Total',
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    '',
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
              rows: BlocProvider.of<InvoiceCubit>(context)
                  .getInvoiceItems()!
                  .map((iv) => DataRow(cells: [
                        DataCell(SizedBox(
                            width: 150, child: Text(iv.product.productName))),
                        DataCell(SizedBox(
                          width: 250,
                          child: Tooltip(
                              message: iv.product.productDescription,
                              child: Text(
                                iv.product.productDescription,
                                overflow: TextOverflow.ellipsis,
                              )),
                        )),
                        DataCell(SizedBox(
                            width: 60,
                            child: NumericText(text: iv.price.toString()))),
                        DataCell(SizedBox(
                            width: 40, child: Text(iv.quantity.toString()))),
                        DataCell(SizedBox(
                            width: 40, child: Text(iv.product.productUnit))),
                        DataCell(SizedBox(
                            width: 60,
                            child: NumericText(text: iv.amount.toString()))),
                        DataCell(GestureDetector(
                          child: const Icon(
                            Icons.delete,
                            size: 15,
                            color: Colors.red,
                          ),
                          onTap: () => _deleteItem(iv),
                        )),
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
                    poNumber,
                    purchaseDate,
                    dueDate,
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    tinNumber,
                    paymentType,
                    paymentTerm,
                    const Padding(
                        padding: EdgeInsets.all(5.0),
                        child: SizedBox(width: 200)),
                  ],
                ),
              ],
            ),
          ),
          invoiceItemDataTable,
          SizedBox(
            width: 820,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text('Total Amount: '),
                SizedBox(
                    height: 60,
                    width: 100,
                    child: StreamBuilder<double>(
                        stream: BlocProvider.of<InvoiceCubit>(context)
                            .totalAmountStream,
                        builder: (context, snapshot) {
                          return CustomLabelTextField(
                            controller: totalAmountController,
                            enabled: false,
                          );
                        })),
              ],
            ),
          ),
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
                      child: AddItemDialog(addInvoiceItem: _addItem),
                    );
                  });
            },
          ),
          Row(
            children: [
              StreamBuilder<bool>(
                  stream: BlocProvider.of<InvoiceCubit>(context).buttonValid,
                  builder: (context, snapshot) {
                    return ElevatedButton(
                      child: Text("Save"),
                      onPressed: snapshot.hasData &&
                              BlocProvider.of<InvoiceCubit>(context)
                                  .getInvoiceItems()!
                                  .isNotEmpty
                          ? () {
                              print('hello');
                            }
                          : null,
                    );
                  }),
            ],
          )
        ],
      ),
    );
  }
}
