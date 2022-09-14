import 'package:edar_app/cubit/products/products_cubit.dart';
import 'package:edar_app/cubit/purchases/purchase_cubit.dart';
import 'package:edar_app/data/model/purchase/purchase_item.dart';

import 'package:edar_app/presentation/utils/util.dart';
import 'package:edar_app/presentation/widgets/fields/custom_label_text_field.dart';
import 'package:edar_app/presentation/widgets/fields/numeric_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PurchaseDatatable extends StatelessWidget {
  const PurchaseDatatable({
    required this.deletePurchaseItem,
    required this.addPurchaseItem,
    super.key,
  });
  final Function(PurchaseItem) deletePurchaseItem;
  final Function(PurchaseItem) addPurchaseItem;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1000,
      child: Column(
        children: [
          StreamBuilder<List<PurchaseItem>>(
            stream: BlocProvider.of<PurchaseCubit>(context).purchaseItemsStream,
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
                          'Product',
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
                          'Purchase Amount',
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
                          'Quantity',
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
                  rows: BlocProvider.of<PurchaseCubit>(context)
                      .getPurchaseItems()!
                      .map((iv) => DataRow(cells: [
                            DataCell(SizedBox(
                              width: 260,
                              child: Tooltip(
                                  message: iv.product.productName,
                                  child: Text(
                                    iv.product.productDescription,
                                    overflow: TextOverflow.ellipsis,
                                  )),
                            )),
                            DataCell(SizedBox(
                                width: 100,
                                child: NumericText(
                                    text: iv.purchaseAmount.toString()))),
                            DataCell(SizedBox(
                                width: 100,
                                child: Text(iv.batchQuantity.toString()))),
                            DataCell(SizedBox(
                                width: 100,
                                child: NumericText(
                                    text: iv.itemTotalAmount.toString()))),
                            DataCell(SizedBox(
                              width: 10,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: const Icon(
                                  Icons.delete,
                                  size: 15,
                                  color: Colors.red,
                                ),
                                onPressed: () => deletePurchaseItem(iv),
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
                        return MultiBlocProvider(providers: [
                          BlocProvider.value(
                              value: context.read<ProductsCubit>()),
                          BlocProvider.value(
                              value: context.read<PurchaseCubit>()),
                        ], child: Container()
                            // AddItemDialog(addPurchaseItem: addPurchaseItem),
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
                      stream: BlocProvider.of<PurchaseCubit>(context)
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
