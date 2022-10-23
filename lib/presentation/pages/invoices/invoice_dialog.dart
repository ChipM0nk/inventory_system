import 'package:edar_app/data/model/invoice/invoice.dart';
import 'package:edar_app/presentation/widgets/fields/custom_text_field.dart';
import 'package:flutter/material.dart';

class InvoiceDialog extends StatelessWidget {
  final Invoice invoice;
  final int? fontSize;
  const InvoiceDialog({required this.invoice, this.fontSize = 10, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text("Invoice Details"),
      content: SizedBox(
        width: 1000,
        height: 800,
        child: Column(
          children: [
            Row(children: [
              CustomTextField(
                initialValue: invoice.invoiceNo.toString(),
                labelText: "Invoice No",
              ),
              CustomTextField(
                initialValue: invoice.invoiceNo.toString(),
                labelText: "Customer Name",
              ),
              CustomTextField(
                initialValue: invoice.invoiceNo.toString(),
                labelText: "Customer Address",
                width: 450,
              )
            ]),
          ],
        ),
      ),
    );
  }
}
