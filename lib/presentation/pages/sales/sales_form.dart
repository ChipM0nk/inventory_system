import 'package:edar_app/cubit/invoice/invoice_cubit.dart';

import 'package:edar_app/data/model/invoice_item.dart';
import 'package:edar_app/presentation/pages/sales/sales_datatable.dart';
import 'package:edar_app/presentation/widgets/fields/custom_date_picker.dart';
import 'package:edar_app/presentation/widgets/fields/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/invoice_item_model.dart';

import '../../widgets/fields/custom_text_field.dart';

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
    BlocProvider.of<InvoiceCubit>(context).init();
    BlocProvider.of<InvoiceCubit>(context).updatePaymentTerm('Cash');

    super.initState();
  }

  void _addItem(InvoiceItem invoiceItem) {
    BlocProvider.of<InvoiceCubit>(context).addInvoiceItem(invoiceItem);
  }

  void _deleteItem(InvoiceItem invoiceItem) {
    BlocProvider.of<InvoiceCubit>(context).removeInvoiceItem(invoiceItem);
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
            width: 465,
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
          onChanged: (dateTime) {
            BlocProvider.of<InvoiceCubit>(context).updatePurchaseDate(dateTime);
          },
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
      onChanged: (dateTime) {
        BlocProvider.of<InvoiceCubit>(context).updateDueDate(dateTime);
      },
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

    return Align(
      alignment: Alignment.topLeft,
      child: SizedBox(
        width: 1000,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
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
                    const SizedBox(width: 200),
                  ],
                ),
              ],
            ),
            SalesDataTable(
              deleteInvoiceItem: _deleteItem,
              addInvoiceItem: _addItem,
            ),
            Row(
              children: [
                StreamBuilder<bool>(
                    stream: BlocProvider.of<InvoiceCubit>(context).buttonValid,
                    builder: (context, snapshot) {
                      return ElevatedButton(
                        onPressed: snapshot.hasData &&
                                BlocProvider.of<InvoiceCubit>(context)
                                    .getInvoiceItems()!
                                    .isNotEmpty
                            ? () {}
                            : null,
                        child: const Text("Save"),
                      );
                    }),
              ],
            )
          ],
        ),
      ),
    );
  }
}
