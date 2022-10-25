import 'package:edar_app/cubit/invoice/invoice_cubit.dart';
import 'package:edar_app/data/model/invoice/invoice.dart';
import 'package:edar_app/presentation/pages/invoices/datagrid/invoice_item_datagrid.dart';
import 'package:edar_app/presentation/widgets/fields/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InvoiceDialog extends StatelessWidget {
  final Invoice invoice;
  final int? fontSize;
  final bool flgAddInvoice;
  const InvoiceDialog(
      {required this.invoice,
      this.fontSize = 10,
      this.flgAddInvoice = false,
      super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InvoiceCubit, InvoiceState>(
      builder: (context, state) {
        if (state is InvoiceAdded) {
          Navigator.of(context, rootNavigator: true).pop();
        }
        return AlertDialog(
          title: const Text("Invoice Details"),
          content: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SizedBox(
              width: 1000,
              height: 450,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField(
                        initialValue: invoice.invoiceNo.toString(),
                        labelText: "Invoice No",
                        enabled: false,
                      ),
                      CustomTextField(
                        initialValue: invoice.customerName.toString(),
                        labelText: "Customer Name",
                        enabled: false,
                      ),
                      CustomTextField(
                        initialValue: invoice.customerAddress.toString(),
                        labelText: "Customer Address",
                        width: 465,
                        enabled: false,
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField(
                        initialValue: invoice.contactNo,
                        labelText: "Contact Number",
                        enabled: false,
                      ),
                      CustomTextField(
                        initialValue: invoice.poNumber,
                        labelText: "PO Number",
                        enabled: false,
                      ),
                      CustomTextField(
                        initialValue: invoice.paymentType,
                        labelText: "Payment Type",
                        enabled: false,
                      ),
                      CustomTextField(
                        initialValue: invoice.paymentTerm,
                        labelText: "Payment Term",
                        enabled: false,
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField(
                        initialValue: invoice.tinNumber,
                        labelText: "TIN Number",
                        enabled: false,
                      ),
                      CustomTextField(
                        initialValue: invoice.purchaseDate,
                        labelText: "Purchase Date",
                        enabled: false,
                      ),
                      CustomTextField(
                        initialValue: invoice.dueDate,
                        labelText: "Due Date",
                        enabled: false,
                      ),
                      const SizedBox(width: 200),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                          height: 250,
                          child: InvoiceItemDataGrid(invoice: invoice)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actionsPadding: const EdgeInsets.all(40),
          actions: [
            Center(
              child: SizedBox(
                width: 200,
                height: 70,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF08B578),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: flgAddInvoice
                      ? () {
                          BlocProvider.of<InvoiceCubit>(context).addInvoice();
                        }
                      : () {},
                  child: Center(
                    child: Text(
                      flgAddInvoice ? "SUBMIT" : "PRINT",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
