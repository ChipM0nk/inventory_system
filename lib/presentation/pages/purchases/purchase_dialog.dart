import 'package:edar_app/cubit/purchases/purchase_cubit.dart';
import 'package:edar_app/data/model/purchase/purchase.dart';
import 'package:edar_app/presentation/pages/purchases/datagrid/purchase_item_datagrid.dart';
import 'package:edar_app/presentation/widgets/custom_elevated_button.dart';
import 'package:edar_app/presentation/widgets/custom_inline_label.dart';
import 'package:edar_app/presentation/widgets/fields/error_message_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class PurchaseDialog extends StatelessWidget {
  final Purchase purchase;
  final int? fontSize;
  final bool flgAddPurchase;
  const PurchaseDialog(
      {required this.purchase,
      this.fontSize = 10,
      this.flgAddPurchase = false,
      super.key});

  @override
  Widget build(BuildContext context) {
    var stackHeaderRows = <StackedHeaderRow>[
      StackedHeaderRow(cells: [
        StackedHeaderCell(
            columnNames: ['prodname', 'proddesc', 'price', 'qty', 'total'],
            child: Container(
              color: Colors.grey[100],
              child: Padding(
                padding: const EdgeInsets.only(top: 15, left: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          CustomInlineLabel(
                              label: "Purchase No: ",
                              value: purchase.purchaseNo),
                        ]),
                        Row(children: [
                          CustomInlineLabel(
                              label: "Supplier: ",
                              value: purchase.supplier.supplierName),
                          CustomInlineLabel(
                              label: "Batch Code: ", value: purchase.batchCode),
                        ]),
                        Row(children: [
                          CustomInlineLabel(
                              label: "Purchase Date: ",
                              value: purchase.purchaseDate),
                          CustomInlineLabel(
                              width: 600,
                              label: "Remarks: ",
                              value: purchase.remarks),
                        ]),
                      ],
                    )
                  ],
                ),
              ),
            ))
      ]),
    ];

    var serviceErrorMessage = StreamBuilder(
      stream: BlocProvider.of<PurchaseCubit>(context).errorStream,
      builder: (context, snapshot) {
        return snapshot.hasError
            ? Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: ErrorMessage(
                  snapshot: snapshot,
                  fontSize: 14,
                  height: 20,
                ),
              )
            : const SizedBox();
      },
    );
    return BlocBuilder<PurchaseCubit, PurchaseState>(
      builder: (context, state) {
        if (state is PurchaseAdded) {
          Navigator.of(context, rootNavigator: true).pop();
        }
        return AlertDialog(
          title: const Text("Purchase Details"),
          content: Column(
            children: [
              SizedBox(
                width: 1000,
                height: 540,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 500,
                      child: PurchaseItemDataGrid(
                        purchaseItems: purchase.purchaseItems,
                        summaryTotal: purchase.totalAmount,
                        stackHeaderRows: stackHeaderRows,
                        editable: false,
                      ),
                    ),
                    serviceErrorMessage,
                  ],
                ),
              ),
            ],
          ),
          actionsPadding: const EdgeInsets.only(bottom: 40),
          actions: [
            Center(
              child: SizedBox(
                width: 170,
                height: 70,
                child: CustomElevatedButton(
                  onPressed: flgAddPurchase
                      ? () {
                          BlocProvider.of<PurchaseCubit>(context).addPurchase();
                        }
                      : () {},
                  child: Center(
                    child: Text(
                      flgAddPurchase ? "SUBMIT" : "PRINT",
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