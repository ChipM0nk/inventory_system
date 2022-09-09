import 'package:edar_app/cubit/invoice/invoice_cubit.dart';
import 'package:edar_app/cubit/products/products_cubit.dart';
import 'package:edar_app/data/model/invoice_item.dart';
import 'package:edar_app/presentation/pages/sales/add_item_dialog.dart';
import 'package:edar_app/presentation/utils/util.dart';
import 'package:edar_app/presentation/widgets/fields/custom_label_text_field.dart';
import 'package:edar_app/presentation/widgets/fields/numeric_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class SalesDataTable extends StatelessWidget {
  const SalesDataTable({
    required this.deleteInvoiceItem,
    required this.addInvoiceItem,
    super.key,
  });
  final Function(InvoiceItem) deleteInvoiceItem;
  final Function(InvoiceItem) addInvoiceItem;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1000,
      child: Column(
        children: [
          StreamBuilder<List<InvoiceItem>>(
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
                        width: 180,
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
                        width: 260,
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
                        width: 100,
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
                        width: 50,
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
                        width: 100,
                        child: Text(
                          'Total',
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: 10,
                        child: Text(
                          '',
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                  rows: BlocProvider.of<InvoiceCubit>(context)
                      .getInvoiceItems()!
                      .map((iv) => DataRow(cells: [
                            DataCell(SizedBox(
                                width: 180,
                                child: Text(iv.product.productName))),
                            DataCell(SizedBox(
                              width: 260,
                              child: Tooltip(
                                  message: iv.product.productDescription,
                                  child: Text(
                                    iv.product.productDescription,
                                    overflow: TextOverflow.ellipsis,
                                  )),
                            )),
                            DataCell(SizedBox(
                                width: 100,
                                child: NumericText(text: iv.price.toString()))),
                            DataCell(SizedBox(
                                width: 60,
                                child: Text(iv.quantity.toString()))),
                            DataCell(SizedBox(
                                width: 50,
                                child: Text(iv.product.productUnit))),
                            DataCell(SizedBox(
                                width: 100,
                                child:
                                    NumericText(text: iv.amount.toString()))),
                            DataCell(SizedBox(
                              width: 10,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: const Icon(
                                  Icons.delete,
                                  size: 15,
                                  color: Colors.red,
                                ),
                                onPressed: () => deleteInvoiceItem(iv),
                              ),
                            )),
                          ]))
                      .toList(),
                ),
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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
                            BlocProvider.value(
                                value: context.read<InvoiceCubit>()),
                          ],
                          child: AddItemDialog(addInvoiceItem: addInvoiceItem),
                        );
                      });
                },
              ),
              Row(
                children: [
                  const Text(
                    'Total Amount: ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(
                    height: 60,
                    width: 120,
                    child: StreamBuilder<double>(
                      stream: BlocProvider.of<InvoiceCubit>(context)
                          .totalAmountStream,
                      builder: (context, snapshot) {
                        final totalAmountController = TextEditingController();

                        totalAmountController.text = snapshot.hasData
                            ? Util.convertToCurrency(snapshot.data!).toString()
                            : "0.0";

                        return SizedBox(
                          height: 30,
                          child: CustomLabelTextField(
                            fontSize: 18,
                            enabled: false,
                            controller: totalAmountController,
                          ),
                        );
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
